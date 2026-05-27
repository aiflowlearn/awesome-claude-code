# Commands in Depth

You've seen the basic slash commands. This module covers the commands that experienced Claude Code users reach for once the initial workflow is working -- context management, session tools, the bundled skills, and keyboard shortcuts that speed everything up.

## Context and Session Management

Every Claude Code session has a context window. `/context` visualizes it as a colored grid -- green for available, yellow for getting full, red for nearly exhausted. When context gets long, `/compact` compresses the conversation. Pass focus instructions to preserve what matters: `/compact focus on the database migration plan`.

`/branch` creates a parallel conversation from the current point, letting you explore two approaches side by side. `/rewind` rolls back to an earlier point -- useful when Claude went down the wrong path. It optionally reverts file changes too, functioning as an undo for both conversation and code.

Session resumption makes long work possible. `/rename my-feature` saves the current session with a readable name. `/resume my-feature` picks it back up later with full context intact. Export a session to a file or clipboard with `/export` for sharing or archiving.

```
/context
/compact focus on the auth refactor
/branch
/rename auth-refactor-v2
/export auth-refactor-v2.md
```

## Bundled Skills

Claude Code ships with built-in skills that work like commands. These are always available without installation.

`/simplify` reviews recently changed files for code quality, spawning parallel review agents that look at different concerns. `/batch <instruction>` is for large-scale changes across many files -- it plans the work, uses isolated git worktrees, and can coordinate verification and PR-oriented follow-up. `/loop 5m check deploy status` runs a prompt repeatedly on an interval, useful for polling long-running operations.

`/debug` enables verbose logging to help diagnose issues with Claude's behavior or tool use. `/claude-api` loads the Anthropic SDK reference for the project's language -- it activates automatically when it detects imports from `@anthropic-ai/sdk` or the Python `anthropic` package.

```
/simplify
/batch add JSDoc comments to all public functions in src/
/loop 2m check if the build finished
/debug
```

## Fast Mode

Fast mode makes Claude Opus 4.6 approximately 2.5x faster at a higher token cost. It's the same model with the same quality -- just optimized for lower latency. Toggle it with `/fast` inside any session. When enabled, a lightning icon appears next to the prompt bar.

```
/fast          # toggle on/off
/fast on       # explicitly enable
/fast off      # explicitly disable
```

Fast mode switches you to Opus 4.6 automatically if you're on a different model. When you turn it off, you stay on Opus 4.6 -- use `/model` to switch models.

Fast mode and effort level are separate speed levers. `/fast` reduces latency without changing quality. `/effort low` reduces thinking time, which may lower quality on complex tasks. Combine both for maximum speed on straightforward work:

```
/fast
/effort low
```

When the fast mode rate limit is hit, it automatically falls back to standard Opus 4.6 speed (the icon turns gray) and re-enables when the cooldown expires. Fast mode requires extra usage to be enabled on your account and is not available on Bedrock, Vertex AI, or Foundry. Enterprise admins can control availability through managed settings.

## Keyboard Shortcuts and Power Features

`Shift+Tab` cycles through permission modes. The official order is `default`, `acceptEdits`, `plan`, and then optional modes like `bypassPermissions` or `auto` if they are enabled in your environment. This is the fastest way to switch to plan mode for a complex task and back afterward.

`Option+T` (macOS) or `Alt+T` toggles extended thinking -- Claude spends more time reasoning before responding. Use `/effort` to set reasoning depth: `auto`, `low`, `medium`, `high`, or `max` where supported. `max` applies to the current session only and requires Opus 4.6. `Ctrl+O` enters verbose mode to see tool calls and thinking steps as they happen.

`/btw your question` asks a side question without adding it to the conversation history -- useful for checking a fact or asking about syntax without cluttering the context. `Ctrl+B` backgrounds running bash commands and agents so you can give Claude another instruction while they continue working. If you need to kill all background agents, the official shortcut is `Ctrl+X Ctrl+K`.

The `/diff` command opens an interactive diff viewer for uncommitted changes -- better than reading raw git output when you want to review what Claude has done before committing. `/insights` generates a session analysis report with statistics on what was accomplished.

```
# Toggle to plan mode, then back
Shift+Tab
Shift+Tab

/effort high
/btw what's the difference between async and defer on script tags?
```
