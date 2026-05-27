# Workflows and Automation

Build CI/CD integrations, scheduled tasks, and multi-step automation workflows with Claude Code.

Claude Code moves from interactive assistant to active team member when you wire it into your automation infrastructure. This module covers CI/CD integration, scheduled tasks, the GitHub Actions integration, and patterns for building reliable multi-step workflows.

## CI/CD Integration with Programmatic Runs

The `claude -p` flag is the foundation of CI/CD integration. It runs Claude non-interactively, sends a prompt, and returns the result to stdout. Combine it with `--output-format json` for structured parsing, `--permission-mode bypassPermissions` for fully automated runs (no approval prompts), and `--max-turns` to cap execution time.

A common pattern is running Claude as part of a PR review process. Configure it as a GitHub Actions step:

```
- name: Claude Code Review
  run: |
    DIFF=$(git diff origin/main...HEAD)
    REVIEW=$(echo "$DIFF" | claude -p "Review these changes. Output JSON with fields: summary, critical_issues, suggestions" \
      --output-format json \
      --permission-mode bypassPermissions)
    echo "$REVIEW" | jq '.critical_issues[]' >> $GITHUB_STEP_SUMMARY
```

For disposable automation, Claude can generate tests for new code, update documentation when APIs change, run linters and auto-fix issues, or check for security vulnerabilities. Use `--no-session-persistence` to avoid saving a session, and consider `--bare` when you want the cleanest scripted output.

The `/install-github-app` command sets up the official GitHub integration, which allows Claude to respond to `@claude` mentions in PR comments and issues. This runs Claude in a sandboxed environment with access to the PR context.

For autonomous PR monitoring, `/autofix-pr` spawns a Claude Code on the web session that watches your current branch's PR. When CI fails or a reviewer leaves a comment, Claude investigates and pushes a fix. Pass a prompt to narrow scope: `/autofix-pr only fix lint and type errors`. It requires the Claude GitHub App installed on the repository and access to Claude Code on the web.

## Scheduled Tasks and Background Automation

Claude Code supports multiple scheduling patterns. `/loop` creates session-scoped recurring checks while Claude Code is running. `/schedule` is the conversational entry point for cloud scheduled tasks that persist independently of your local terminal — each run clones your repo fresh, executes autonomously, and can push branches or open PRs. Create tasks via `/schedule`, the web UI at claude.ai, or the desktop app. Frequency options include hourly, daily, weekdays, and weekly, with custom cron expressions available via `/schedule update` (minimum interval: 1 hour). Use them to monitor services, generate reports, or perform recurring maintenance:

```
# Check build status every 5 minutes
/loop 5m check if the build succeeded and summarize any failures

# One-time scheduled task
/schedule "run a full security audit at 2am"
```

Background subagents with `background: true` in their frontmatter run without blocking the main conversation. This enables workflows where you kick off a long analysis, continue other work, and get notified when it completes. If you need automation around follow-up work, use the officially documented task and team hook events in their intended contexts: `TaskCompleted` for task state changes and `TeammateIdle` for agent teams teammates about to go idle.

```
{
  "hooks": {
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -X POST $SLACK_WEBHOOK -d '{\"text\": \"Task completed: $TASK_NAME\"}'"
          }
        ]
      }
    ]
  }
}
```

For long-running research that spans multiple sessions, resumable agents and regular memory workflows are the safer mental model: let the agent write findings into memory or project docs, then resume the agent or session later when needed.

## Multi-Step Workflow Patterns

The most reliable workflows combine skills, hooks, and subagents into a pipeline where each step has clear inputs, outputs, and error handling.

The "develop and verify" pattern pairs a `Stop` prompt hook that checks completion criteria against an implementation skill. When Claude stops, the hook evaluates whether all requirements were met. If not, it tells Claude what's missing and Claude continues:

```
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check: 1) Were all files in the spec modified? 2) Do tests pass? 3) Is the implementation complete per the requirements? If anything is incomplete, explain what remains.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

The "parallel review" pattern uses Agent Teams to have multiple specialists review simultaneously. One agent checks security, another checks performance, another checks test coverage. The team lead synthesizes their findings into a single report.

For tasks that modify many files across a codebase, `/batch <instruction>` plans the work, splits it across background agents in isolated git worktrees, and is designed for large-scale refactors or repetitive changes. Depending on the workflow, it can also run verification steps and help open PRs for the results.

Git worktrees (`isolation: worktree` on subagents) are also useful for experimental work. The agent makes changes in an isolated branch, returns the worktree path when done, and you review or discard without affecting your working tree.
