# Advanced Features

Claude Code has a set of power features that experienced users reach for on complex or risky work. Planning mode, extended thinking, auto mode, sandboxing, and headless operation all change how Claude works in fundamental ways. This module covers each one in depth.

## Planning Mode and Extended Thinking

Planning mode separates thinking from doing. When you activate it, Claude first researches the codebase and creates a detailed implementation plan. You review and optionally modify the plan, then Claude executes it. This prevents the common failure mode of Claude starting to code before fully understanding the problem.

Activate it with `/plan `, the `--permission-mode plan` CLI flag, or `Shift+Tab` to cycle permission modes. Use `Ctrl+G` to open the current plan in your external editor for detailed modifications before approving. The `opusplan` model alias routes planning to Opus and execution to Sonnet:

```
claude --model opusplan "redesign the database schema for multi-tenancy"
```

Extended thinking gives Claude more time to reason before responding. Toggle it with `Option+T` (macOS) or `Alt+T`. The `/effort` command sets reasoning depth: `low`, `medium`, `high`, `xhigh`, or `max` (session-only). Set it per-session with `export CLAUDE_CODE_EFFORT_LEVEL=high`. For prompts where you need maximum reasoning, include the word "ultrathink" — it activates deep reasoning mode regardless of the effort setting.

The combination of plan mode plus high effort is powerful for complex architectural decisions:

```
claude --permission-mode plan --effort high --model opusplan "migrate from REST to GraphQL"
```

## Ultraplan: Cloud-Powered Planning

Ultraplan extends planning mode by handing the plan to a Claude Code on the web session. Claude drafts the plan in the cloud while your terminal stays free. You then open it in your browser to comment on specific sections, request revisions, and choose where to execute.

Three ways to launch it: the `/ultraplan ` command, including the word "ultraplan" in a normal prompt, or choosing "Refine with Ultraplan on the web" from a finished local plan dialog.

After launch, a status badge appears at your prompt: `◇ ultraplan` while drafting, `◇ ultraplan needs your input` when Claude has questions, and `◆ ultraplan ready` when the plan is ready for review. Open the session link on claude.ai to review — you can leave inline comments on specific sections, add emoji reactions, and ask for revisions before approving.

When you approve, two execution paths:
* **Execute on the web** — Claude implements the plan in the cloud, and you review the diff and open a PR from the browser
* **Send back to terminal** — the plan teleports to your CLI for local implementation with full access to your environment

```
/ultraplan migrate the auth service from sessions to JWTs
```

Ultraplan requires a claude.ai subscription and a connected GitHub repository. It's not available on Bedrock, Vertex AI, or Foundry.

## Auto Mode and Permission Control

Auto Mode is a research-preview permission mode that uses a background safety classifier to decide whether tool calls are safe to run without prompting. It's designed for higher-autonomy workflows where you still want guardrails around risky actions.

You use it the same way as the other permission modes: select `auto` in your permission settings or cycle to it with `Shift+Tab` when that mode is available in your setup. Organizations can tune what Auto Mode treats as trusted infrastructure with the `autoMode` settings block.

Out of the box, Auto Mode is conservative around actions that look like data exfiltration, risky shell execution, or production-impacting changes. When a permission check stalls, the spinner turns red — making it clear that a check is in progress rather than a tool running. If your team has trusted repos, internal domains, buckets, or services that Auto Mode should treat as normal, define them in `autoMode.environment`.

When customizing `autoMode.allow`, `autoMode.soft_deny`, or `autoMode.environment`, include the special `"$defaults"` token to keep the built-in rules and add yours alongside them. Without `"$defaults"`, your array replaces the defaults entirely:

```
{
  "autoMode": {
    "allow": ["$defaults", "Bash(terraform *)"],
    "environment": ["$defaults", "Internal API: api.corp.example.com"]
  }
}
```

Permission modes span a spectrum. `default` reads freely but prompts for actions beyond that. `acceptEdits` auto-approves file edits for the session, except writes to protected directories. `plan` switches into planning-first research mode. `auto` uses the classifier. `dontAsk` only runs pre-approved tools and denies everything else. `bypassPermissions` skips most permission prompts, but writes to protected directories (`.git`, `.claude`, `.vscode`, `.idea`, `.husky`) still prompt for confirmation. The `--dangerously-skip-permissions` flag is a shorthand for `--permission-mode bypassPermissions` — the deliberately alarming name makes the security trade-off explicit, so reserve it for trusted CI/CD pipelines.

Start a session in any mode with the `--permission-mode ` flag. It accepts `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, or `bypassPermissions`, and overrides `defaultMode` from your settings files for that run — so you can pin a stricter mode for one-off automation without editing config. The same flag works with `-p` for non-interactive runs, and `dontAsk` only ever activates through this flag (it's not in the `Shift+Tab` cycle):

```
claude --permission-mode plan "draft the migration"
claude -p "audit dependencies" --permission-mode dontAsk
```

Set a default in settings so most sessions start in the mode you want without passing the flag:

```
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

To customize Auto Mode for your environment:

```
{
  "autoMode": {
    "environment": [
      "Source control: github.example.com/acme-corp and all repos under it",
      "Trusted internal domains: *.corp.example.com, api.internal.example.com"
    ]
  }
}
```

## Programmatic and Sandboxed Operation

Running Claude Code programmatically with `claude -p "your prompt"` executes it non-interactively. Output goes to stdout, making it composable with shell pipelines and automation systems. Combine it with `--output-format json` for structured output. Use `--permission-mode bypassPermissions` for fully automated CI/CD use. Hooks running in these sessions can read the active effort level via the `$CLAUDE_EFFORT` environment variable.

```
# Automated code review in CI
git diff HEAD~1 | claude -p "review these changes for security issues" \
  --output-format json \
  --permission-mode bypassPermissions

# Generate docs for changed files
claude -p "generate JSDoc for all functions in $CHANGED_FILE" \
  --print --no-session-persistence
```

Sandboxing provides OS-level isolation for file system and network access. Enable it with `/sandbox` in-session. In sandbox mode, Claude can only access approved paths and network rules you configure. This is valuable for running Claude on untrusted code or in environments where you want strict boundaries.

Fine-tune network isolation with `sandbox.network.allowedDomains` and `sandbox.network.deniedDomains` in your `settings.json`. `allowedDomains` whitelists domains for outbound traffic, while `deniedDomains` blocks specific domains even when a broader wildcard in `allowedDomains` would permit them — `deniedDomains` always takes precedence. Both support wildcards like `*.example.com`:

```
{
  "sandbox": {
    "enabled": true,
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "deniedDomains": ["uploads.github.com"]
    }
  }
}
```

In managed deployments, `deniedDomains` is merged from **all** settings sources (managed, user, project, local) regardless of `allowManagedDomainsOnly`. That flag only restricts which scopes `allowedDomains` is read from — deny rules from any scope are always honored, so a user-level block cannot be silently dropped by enterprise policy.

On Linux and WSL, use `sandbox.bwrapPath` and `sandbox.socatPath` to specify custom binary locations for bubblewrap and socat:

```
{
  "sandbox": {
    "bwrapPath": "/usr/local/bin/bwrap",
    "socatPath": "/usr/bin/socat"
  }
}
```

For enterprise deployments, managed settings override user settings through platform-native management: plist on macOS, Registry on Windows, managed configuration files, and `managed-settings.d/` drop-ins merged alphabetically. That's separate from managed memory files such as organization-level `CLAUDE.md` guidance.

```
# Test headless with sandboxing
claude -p "analyze the security of this codebase" \
  --sandbox \
  --permission-mode plan \
  --output-format json
```

## Advisor Tool (Experimental)

The Advisor Tool is an experimental dual-model feature that lets a faster, lower-cost executor model (like Sonnet) consult a higher-intelligence advisor model (like Opus) mid-task for strategic guidance. The advisor reads the full conversation and produces a plan or course correction, then the executor continues with the task. This pattern fits long-horizon agentic workloads where most turns are mechanical but having an excellent plan is crucial.

Enable it with the `/advisor` command. When active, sessions show an "experimental" label and a startup notification. The executor model is set as the main session model, and the advisor model is selected through the `/advisor` dialog.

## Native Glob and Grep on macOS/Linux

On native macOS and Linux builds, the `Glob` and `Grep` tools are replaced by embedded `bfs` and `ugrep` binaries available through the Bash tool. The result is faster file searches without a separate tool round-trip — Claude issues a single Bash command instead of calling a dedicated tool, which reduces latency on large codebases.

Windows and npm-installed builds are unaffected and continue using the original Glob and Grep tools. The environment variables `CLAUDE_CODE_GLOB_HIDDEN`, `CLAUDE_CODE_GLOB_NO_IGNORE`, and `CLAUDE_CODE_GLOB_TIMEOUT_SECONDS` still apply to the original tools where they remain in use.

## Session Cleanup with cleanupPeriodDays

The `cleanupPeriodDays` setting in `settings.json` controls how long session files are retained before automatic deletion at startup. The default is 30 days and the minimum is 1 — setting it to `0` is rejected with a validation error. The setting also controls automatic removal of orphaned subagent worktrees (from crashes or interrupted parallel runs) at startup, provided they have no uncommitted changes, no untracked files, and no unpushed commits. Worktrees you create with `--worktree` are never removed by this sweep:

```
{
  "cleanupPeriodDays": 14
}
```

To keep transcripts from being written at all in non-interactive mode, use `--no-session-persistence` or the `CLAUDE_CODE_SKIP_PROMPT_HISTORY` environment variable.

## Project Purge

When `cleanupPeriodDays` isn't enough and you want to wipe all Claude Code state for a project right now, use `claude project purge`. It deletes transcripts, task lists, debug logs, file-edit history, prompt history, and the project entry itself:

```
# Preview what would be deleted
claude project purge --dry-run

# Purge state for the current project
claude project purge

# Skip the confirmation prompt
claude project purge --yes

# Interactively choose which items to remove
claude project purge --interactive

# Purge state for every project at once
claude project purge --all
```

Flags can be combined: `claude project purge --all --dry-run` previews what a full wipe would remove. The `-y` and `-i` short forms work too.

## Debugging and Platform Environment Variables

A few environment variables unlock surfaces that aren't exposed as commands or settings yet.

`OTEL_LOG_RAW_API_BODIES=1` emits full API request and response bodies as OpenTelemetry log events — set it when debugging why a request failed or what exactly Claude sent to the model. Be careful with the logs afterwards since request bodies can contain secrets.

`CLAUDE_CODE_USE_POWERSHELL_TOOL=1` opts into the PowerShell tool on Linux and macOS (requires `pwsh` on PATH). On Windows the tool is rolling out progressively; set it to `0` to opt out explicitly. On Windows with the PowerShell tool enabled, PowerShell becomes the primary shell instead of defaulting to Bash.

`DISABLE_UPDATES=1` blocks all update paths, including manual `claude update`. This is stricter than `DISABLE_AUTOUPDATER` (which only blocks auto-updates) and is intended for locked-down enterprise deployments where the installed version must not change.

`CLAUDE_CODE_HIDE_CWD=1` hides the working directory from the startup logo banner. Useful for screen recordings or presentations where you don't want to leak path information.

`CLAUDE_CODE_NATIVE_CURSOR=1` shows the terminal's own cursor at the input caret instead of Claude Code's drawn block. The native cursor respects the terminal's blink, shape, and focus settings — useful when your terminal is configured for a specific cursor style or accessibility need.

`CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1` pins fast mode to Claude Opus 4.6 even when the default has moved on. It takes precedence over `CLAUDE_CODE_ENABLE_OPUS_4_7_FAST_MODE`, so set it when you need Opus 4.6 specifically regardless of how the default changes.

`CLAUDE_CODE_RESUME_PROMPT` overrides the continuation message Claude injects when resuming a session that ended mid-turn. The default is `Continue from where you left off.`. Long-running spawn scripts can set a more directive boot message; an empty string falls back to the default.

`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1` routes the "How is Claude doing?" session quality survey to your own OpenTelemetry collector when Anthropic-bound nonessential traffic is blocked. Survey ratings are emitted only as OTEL events to your configured collector — no survey data is sent to Anthropic. It applies when `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`, `DISABLE_TELEMETRY`, or `DO_NOT_TRACK` is set, and has no effect otherwise. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY` and your organization's product feedback policy still take precedence.

`ANTHROPIC_WORKSPACE_ID` is the workspace ID used by workload identity federation. Set it when your federation rule is scoped to more than one workspace so the token exchange knows which workspace to target — without it, an over-scoped rule has no way to pick a workspace and the exchange fails. Leave it unset when your federation rule is scoped to exactly one workspace.

```
# Capture full OTEL telemetry while reproducing an API bug
OTEL_LOG_RAW_API_BODIES=1 claude --print 'reproduce the failure'

# Enable PowerShell tool on macOS or Linux
CLAUDE_CODE_USE_POWERSHELL_TOOL=1 claude

# Block all updates on a locked-down machine
DISABLE_UPDATES=1 claude

# Hide the working directory in the startup banner
CLAUDE_CODE_HIDE_CWD=1 claude

# Use the terminal's own cursor at the input caret
CLAUDE_CODE_NATIVE_CURSOR=1 claude

# Pin fast mode to Opus 4.6 regardless of the default
CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1 claude

# Override the resume continuation message for an agent boot script
CLAUDE_CODE_RESUME_PROMPT="Resume the migration and stop after the next test run." \
claude --resume

# Route the session quality survey through your OTEL collector
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1 claude

# Workload identity federation with a multi-workspace rule
ANTHROPIC_WORKSPACE_ID=ws_01abcd... claude
```

## Claude Code on the Web and Session Handoff

Claude Code on the web runs tasks on Anthropic-managed cloud infrastructure at claude.ai/code. Cloud sessions persist even when you close your browser, and you can monitor them from the Claude mobile app.

Launch a cloud session from your terminal with `claude --remote "your task"`. Claude clones your repo from GitHub (push local commits first), executes the prompt autonomously, and can open PRs when done. Use multiple `--remote` calls to run tasks in parallel.

`/teleport` (alias `/tp`) pulls a cloud session back into your local terminal — it fetches the branch, loads the full conversation history, and lets you continue locally. The reverse direction: `--remote` sends work to the cloud. Together they create a seamless loop between local and cloud execution.

`/autofix-pr` spawns a cloud session that watches your current PR. When CI fails or reviewers leave comments, Claude investigates and pushes a fix. Pass a prompt to narrow its scope: `/autofix-pr only fix lint and type errors`. Requires the Claude GitHub App installed on the repository.

```
# Plan locally, execute in the cloud
claude --permission-mode plan
# ... finalize plan, commit, push ...
claude --remote "Execute the migration plan in docs/migration-plan.md"
# Pull the cloud session back when done
/teleport
```

Cloud sessions include standard runtimes (Node.js, Python, Go, Rust, Java, Ruby, Docker, PostgreSQL), up to 16 GB RAM, and configurable network access levels. Repo-level configuration (CLAUDE.md, settings, MCP servers, skills) carries over automatically. User-level settings (~/.claude/) do not — commit project config to the repo.

## PR URL Customization

The `prUrlTemplate` setting in `settings.json` points the footer PR badge at a custom code-review URL instead of the default GitHub link. This is useful for teams using GitLab, Bitbucket, or an internal review tool:

```
{
  "prUrlTemplate": "https://gitlab.example.com/org/repo/-/merge_requests/{{pr_number}}"
}
```

## Worktree Configuration

Git worktrees let you check out multiple branches simultaneously without stashing or branching. `claude --worktree ` creates a new worktree linked to `/<worktree-name>`. The `worktree.baseRef` setting (new in v2.1.133) controls which ref to branch from when creating a worktree. Set `baseRef` to `head` (local `HEAD`, the default) or `fresh` (`origin/<default-branch>` — branches from the default remote ref):

```
{
  "worktree": {
    "baseRef": "head"
  }
}
```

Setting `head` preserves unpushed local commits in new worktrees. This affects `--worktree`, `EnterWorktree`, and agent-isolation worktrees.

## More Advanced Features

Claude Code's advanced toolkit goes further. Background tasks let long-running work continue while you keep chatting. Scheduled tasks support `/loop` for session-scoped recurring checks and `/schedule` for cloud-backed scheduled work. Session tools like `/resume`, `/rename`, and `/teleport` make it easy to move between local CLI, the browser, and the desktop app.

There are also platform features for daily use: voice dictation with `/voice`, Chrome integration with `--chrome`, remote control via `/remote-control`, the `/powerup` interactive feature discovery lessons, persistent task lists, and git worktree workflows with `claude --worktree`. These all share the same permission system, so advanced usage is mostly about combining the right mode with the right surface.
