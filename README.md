# awesome-claude-code

> A comprehensive Claude Code learning toolkit — knowledge base, templates, hooks, exercises, and LLM Wiki integration

English | [中文](README.zh-CN.md)

## Why This Toolkit (Not Another Awesome List)

There are already awesome lists with 40,000+ stars linking to resources. This toolkit is different — it provides **working code** you can use immediately:

- 12 comprehensive reference documents covering Claude Code v2.1.x
- Ready-to-use CLAUDE.md templates for any project type
- Working claude code hooks for automated code review and workflow reminders
- 28 hands-on exercises with clear objectives
- llm wiki integration for persistent knowledge management

If you are searching for a practical claude code tutorial, claude code configuration examples, claude code MCP notes, claude code skills patterns, or claude code best practices, start here.

## Quick Start

```bash
# Use a CLAUDE.md template
cp templates/claude-md/minimal.md YOUR_PROJECT/CLAUDE.md

# Use a hook
cp templates/hooks/stop-review-check.sh ~/.claude/hooks/

# Start learning
cd exercises/stage-01-meet && cat *.md
```

## Knowledge Base

| # | Topic | What You'll Learn |
|---|-------|-------------------|
| 00 | Getting Started | Install, auth, IDE extensions, first session |
| 01 | Slash Commands | Built-in commands reference |
| 02 | Memory (CLAUDE.md) | Hierarchy, auto memory, claudeMdExcludes |
| 03 | Project Setup | /init, permissions, settings precedence |
| 04 | Commands Deep Dive | Context, sessions, fast mode |
| 05 | Skills | Skill creation, dynamic context, arguments |
| 06 | Hooks | PreToolUse/PostToolUse patterns |
| 07 | MCP | MCP servers, scopes, security practices |
| 08 | Subagents | Creating subagents, chaining, isolation |
| 09 | Advanced Features | Planning mode, auto mode, sandboxing |
| 10 | Workflows | CI/CD integration, cron, /batch |
| 11 | Plugins | Plugin architecture, marketplace |

## Templates

| Template | Use Case |
|----------|----------|
| `templates/claude-md/minimal.md` | Minimal CLAUDE.md template from the config pack |
| `templates/claude-md/production.md` | Production constitution with verification SOP |
| `templates/claude-md/frontend.md` | Component libraries, styling, and state management |
| `templates/claude-md/backend.md` | APIs, databases, and error handling |
| `templates/claude-md/fullstack.md` | Monorepo fullstack projects |
| `templates/settings/settings.example.json` | Example Claude Code settings |
| `templates/commands/*.md` | Reusable slash command templates |

## Hooks

- `stop-review-check.sh`: a stop hook that reminds the agent to review and verify work before completion.
- `workflow-reminder.sh`: a workflow reminder hook for safer Claude Code sessions.

These claude code hooks are MIT licensed so you can copy them into your own projects.

## LLM Wiki Integration

The `wiki/` directory shows how to combine Claude Code with Karpathy's llm wiki pattern and `llm-wiki-manager`. Use it to turn raw notes, docs, transcripts, and decisions into a durable claude code knowledge base.

## Exercises (28 Hands-On Tasks)

| Stage | Directory | Focus | Task Count |
|-------|-----------|-------|------------|
| 01 | `exercises/stage-01-meet/` | Meet Claude Code | 7 |
| 02 | `exercises/stage-02-setup/` | Project setup and CLAUDE.md | 7 |
| 03 | `exercises/stage-03-skills/` | Skills and automation | 6 |
| 04 | `exercises/stage-04-advanced/` | Reading and modifying code | 5 |
| 05 | `exercises/stage-05-build/` | Build a CLI tool | 3 |

## FAQ

### What is different from awesome lists?

Awesome lists mostly link out. This claude code toolkit ships working templates, hooks, exercises, and knowledge files you can copy directly.

### How do I use a CLAUDE.md template?

Copy one file from `templates/claude-md/` to your project root as `CLAUDE.md`, then edit the project-specific rules.

### Which template should I start with?

Use `minimal.md` for small projects, `production.md` for serious repos, and domain templates for frontend, backend, or fullstack work.

### What is LLM Wiki?

An llm wiki is a structured knowledge base that converts raw sources into linked entities, concepts, and notes for AI agents.

### Does this cover claude code MCP?

Yes. The knowledge base includes MCP server setup, scopes, and security practices.

### Does this cover claude code skills?

Yes. The skills chapter explains skill structure, dynamic context, and arguments, while exercises help you practice.

### Can I use the hooks commercially?

Yes. Hooks, settings, and command templates are MIT licensed. Content directories use CC BY-NC-SA 4.0.

### Is Claude Code the best ai coding tool 2026?

It depends on your workflow. This repo focuses on Claude Code's strengths: repository-wide context, terminal workflows, hooks, skills, MCP, and repeatable verification.

### Claude Code vs Cursor: which should I learn?

Cursor is IDE-first. Claude Code is agentic and terminal-first. Many teams use both: Cursor for interactive editing, Claude Code for larger repo tasks and automation.

## Online Practice

Practice these exercises in a browser-based environment at [Zero2Claude](https://zero2claude.aiflowlearn.net/) — no installation required.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## More from AIFlowLearn

- [awesome-claude-code](https://github.com/aiflowlearn/awesome-claude-code) — This repo
- [zero2claude](https://github.com/aiflowlearn/zero2claude) — Learn Claude Code from zero
- [zero2codex](https://github.com/aiflowlearn/zero2codex) — Learn Codex CLI from zero
- [zero2cursor](https://github.com/aiflowlearn/zero2cursor) — Learn Cursor IDE from zero
- [zero2codewhale](https://github.com/aiflowlearn/zero2codewhale) — Learn CodeWhale from zero
- [ai-coding-skillpacks](https://github.com/aiflowlearn/ai-coding-skillpacks) — 21 AI coding learning paths
- [9router-starter-kit](https://github.com/aiflowlearn/9router-starter-kit) — AI model routing in 5 minutes

## License

- Code (hooks, settings, commands): [MIT](LICENSE-MIT)
- Content (knowledge, exercises, wiki schemas): [CC BY-NC-SA 4.0](LICENSE-CC-BY-NC-SA)

---

*Sponsored by [AIFlowLearn](https://aiflowlearn.net) — AI-native learning platform*

**[AIFlowLearn / AI智流学社](https://aiflowlearn.net)** — Browser-based AI coding practice environments, interactive courses, and skill packs.

[Zero2Claude](https://zero2claude.aiflowlearn.net/) | [Zero2Codex](https://zero2codex.aiflowlearn.net/) | [All Skill Packs](https://aiflowlearn.net/skillpacks)
