# Subagents

Delegate complex tasks to specialized AI agents with isolated context windows and custom system prompts.

Subagents let Claude delegate work to specialized AI assistants, each with their own context window, tools, and system prompt. They prevent context pollution on long tasks, enable parallel execution, and let you encode domain expertise into reusable agents. This module covers creating, configuring, and using subagents effectively.

## Creating Subagents

Subagents are markdown files with YAML frontmatter. You can define them with the `--agents` CLI flag for one session, put them in `.claude/agents/` for project scope (committed to git), or `~/.claude/agents/` for personal scope (all projects). Plugins can bundle agents too. Priority is managed (policy) > CLI-defined > project > user > plugin > built-in. The `/agents` command provides an interactive menu to create, edit, and manage them.

The frontmatter defines the agent's identity. The markdown body is its system prompt — write this like you're briefing a specialist:

```
---
name: security-reviewer
description: Security-focused code reviewer. Use proactively after writing authentication, authorization, or data handling code.
tools: Read, Grep, Glob
---

You are a senior security engineer specializing in application security.

Review priorities:
1. Authentication and authorization flaws
2. Injection vulnerabilities (SQL, XSS, command)
3. Data exposure and sensitive information handling
4. Cryptographic weaknesses
5. Insecure direct object references

For each finding, provide: severity (Critical/High/Medium/Low), location (file:line), description, and a concrete fix with code example.

When invoked: run `git diff HEAD` first to focus on changed code.
```

The `tools` field restricts which tools the agent can use. A security reviewer only needs `Read`, `Grep`, and `Glob` — no write access. An implementation agent needs the full set. Restricting tools makes the agent safer and its behavior more predictable. If you omit `tools`, the agent inherits all available tools.

## Configuration Options

Beyond basic tool access, the frontmatter supports several powerful options. `model` sets which model the agent uses — `haiku` for fast, lightweight tasks, `sonnet` for balanced work, or `opus` for complex reasoning. You can also use `inherit` to inherit the parent's model. `effort` controls reasoning depth on supported models such as Sonnet 4.6 and Opus 4.6, with `max` reserved for Opus 4.6. `maxTurns` caps how long the agent can run. `permissionMode` sets the permission level. Other useful fields include `disallowedTools`, `skills` to preload selected skills, `mcpServers` for agent-scoped MCP access, and `initialPrompt` to auto-submit the first turn.

`memory` gives the agent persistent storage across sessions. The first 200 lines of a `MEMORY.md` file in the agent's memory directory load into its system prompt automatically — Claude writes to this file as it learns things:

```
---
name: researcher
memory: user
description: Long-running research assistant with persistent notes
---
You are a research assistant. Check your MEMORY.md at session start to recall previous findings. Update it with new discoveries.
```

`isolation: worktree` gives the agent its own git worktree and branch to make changes without touching your main working tree. When the agent finishes, it returns the worktree path and branch name for you to review and merge. If it made no changes, the worktree is cleaned up automatically. Agents in worktree isolation can also use the `ExitWorktree` tool to explicitly leave the worktree before the task ends — useful when the agent needs to hand off mid-task or signal completion early.

`background: true` makes the agent always run as a background task, freeing the main conversation. Press `Ctrl+B` to background a currently running agent.

## Using and Chaining Subagents

Claude invokes agents automatically when the task description matches the agent's `description` field. Phrases like "use proactively" can encourage delegation, but explicit invocation is the reliable path when you need a specific agent. Use `@"agent-name (agent)"` syntax to guarantee a specific agent is used, bypassing the automatic matching.

Explicit invocation via natural language also works:

```
Use the security-reviewer agent to audit the new auth module.
Have the test-engineer agent write integration tests for the payment service.
Ask the debugger agent to investigate the memory leak in src/workers/queue.ts.
```

Agents can be chained in sequence, with the output of one feeding the next. You can also list all configured agents with `claude agents`, run a full session with a specific one via `claude --agent <name>`, and restrict which agents a coordinator can spawn with `Agent(...)` tool allowlists.

```
First use the code-analyzer agent to find performance bottlenecks, then use the optimizer agent to fix them.
```

Claude Code ships with several built-in agents you don't need to create: `general-purpose` handles broad multi-step tasks, `Explore` uses Haiku for fast read-only codebase analysis, `Plan` researches the codebase before presenting implementation plans, and `claude-code-guide` answers questions about Claude Code features. Agents can also be resumable, letting Claude continue a previous agent conversation by ID when the workflow spans multiple turns.

The experimental Agent Teams feature (requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` or the `--agent-teams` CLI flag) coordinates multiple Claude instances working in parallel via a shared task list and mailbox. This is for large multi-file projects where independent agents can work on different parts simultaneously without stepping on each other. `SendMessage` automatically resumes stopped agents when a message is sent to them, so you no longer need to explicitly resume an agent before communicating with it.
