# Hooks

Automate validation, formatting, notifications, and safety checks with event-driven hooks.

Hooks are scripts that execute automatically when specific events occur during a Claude Code session. They receive JSON input via stdin and communicate results through exit codes and JSON output. Command hooks are deterministic, composable, testable, and language-agnostic. Prompt hooks and agent hooks use a Claude model for evaluation, so their behavior is non-deterministic. This module covers the hook system, the key events, and how to write useful hooks.

## Hook Architecture and Configuration

Hooks are configured in settings files under a `hooks` key. Each event has an array of matchers, and each matcher has an array of hook definitions. The `matcher` field is a regex pattern matched against the tool name — `"Bash"` matches exactly, `"Write|Edit"` matches either, `"*"` matches all tools, `"mcp__github__.*"` matches all GitHub MCP tools.

```
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/validate-bash.py\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

Matchers also support a conditional `if` field (v2.1.85) that uses permission rule syntax to further filter when a hook fires. While `matcher` selects the tool by name, `if` narrows to specific invocations of that tool. This is useful when you only care about a subset of a tool's calls — for example, intercepting `git push` commands without running on every Bash invocation:

```
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(git push*)",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/check-push.sh"
          }
        ]
      }
    ]
  }
}
```

The `if` pattern follows the same syntax as permission rules — `Bash(git *)` matches any git command, `Write(src/**/test_*.py)` matches test file writes, and so on. A hook with an `if` field only triggers when both the `matcher` and the `if` condition match.

Claude Code supports 30+ hook events. The most useful for day-to-day work are `PreToolUse` (validate before a tool runs, can block), `PostToolUse` (observe or react after, can add context), `UserPromptSubmit` (intercept user input before Claude processes it), and `Stop` (run checks when Claude finishes responding). There are also events for permission handling (`PermissionRequest`), notifications, subagent lifecycle (`SubagentStart`, `SubagentStop`), failures (`PostToolUseFailure`, `StopFailure`), config changes, file watching (`FileChanged`), context compaction (`PreCompact`, `PostCompact`), and worktree management.

Several newer events expand what hooks can react to. `CwdChanged` (v2.1.83) fires when the working directory changes, enabling direnv-like reactive environment management — for example, auto-loading environment variables when Claude enters a project directory. `TaskCreated` (v2.1.84) fires when the `TaskCreate` tool is used, so you can log or validate new tasks as they're spawned. `WorktreeCreate` (v2.1.84) fires when a worktree agent is created, and supports `type: "http"` for remote notifications — useful for alerting external services when parallel work begins. `Elicitation` (v2.1.76) fires when an MCP server requests structured user input mid-task via an interactive dialog, and can intercept and modify the elicitation before it's shown to the user. `ElicitationResult` (v2.1.76) fires after the user responds to an MCP elicitation, and can intercept and override the response before it's sent back to the MCP server.

Hook scripts receive JSON via stdin. A Python hook reads it like this:

```
import json, sys
data = json.load(sys.stdin)
tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})
```

Exit code `0` means success (parse JSON stdout for output). Exit code `2` means blocking error — Claude stops and shows your stderr message. Any other exit code is a non-blocking warning shown in verbose mode.

## Common Hook Types and Patterns

Hooks can run four ways. `command` hooks execute local shell commands. `prompt` hooks ask Claude to evaluate a prompt, usually on `Stop` or `SubagentStop`. `agent` hooks spawn a subagent for multi-step validation. `http` hooks POST the same JSON payload to a webhook endpoint, which is useful for remote logging or policy services. HTTP hooks support environment-variable interpolation in headers, and those variables must be explicitly allowlisted.

## Common Hook Patterns

Auto-formatting on file save is one of the most useful hooks. A `PostToolUse` hook on `Write|Edit` runs your formatter automatically, so Claude's output is always clean:

```
#!/bin/bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))")
case "$FILE" in
  *.ts|*.tsx|*.js) prettier --write "$FILE" 2>/dev/null ;;
  *.py) black "$FILE" 2>/dev/null ;;
  *.go) gofmt -w "$FILE" 2>/dev/null ;;
esac
exit 0
```

Security scanning on writes uses `PostToolUse` with `additionalContext` output to warn Claude about potential secrets it just wrote:

```
SECRET_PATTERNS = [
    (r"api[_-]?key\s*=\s*['\"][^'\"]+['\"]", "Potential hardcoded API key"),
    (r"password\s*=\s*['\"][^'\"]+['\"]", "Potential hardcoded password"),
]
# ... check content, then:
output = {"hookSpecificOutput": {"hookEventName": "PostToolUse",
  "additionalContext": f"Security warnings: {'; '.join(warnings)}"}}
print(json.dumps(output))
```

Blocking dangerous commands uses `PreToolUse` with a regex check and exit code 2:

```
BLOCKED = [(r"\brm\s+-rf\s+/", "Blocking dangerous rm -rf /")]
for pattern, message in BLOCKED:
    if re.search(pattern, command):
        print(message, file=sys.stderr)
        sys.exit(2)
```

## Advanced: Prompt Hooks and Component Scope

For `Stop` and `SubagentStop` events, hook type `"prompt"` uses an LLM to evaluate task completion. The LLM reads the conversation and returns a structured decision on whether to let Claude stop or continue working. This is powerful for tasks with explicit completion criteria:

```
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check: 1) Were all files modified? 2) Do tests pass? 3) Is the PR description updated? If anything is missing, explain what.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Hook type `"agent"` spawns a subagent to do the evaluation — unlike prompt hooks (single-turn), agent hooks can use tools and perform multi-step reasoning. Use this when the check requires reading files or running commands.

Hooks can also be scoped to individual skills and agents using the `hooks` frontmatter field. A `PreToolUse` hook in a skill's frontmatter only fires during that skill's execution:

```
---
name: production-deploy
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/production-safety-check.sh"
          once: true
---
```

The `once: true` flag runs the hook only once per session rather than on every matching tool use. This is useful for setup checks that only need to happen once.
