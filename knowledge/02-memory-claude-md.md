# Memory & Context Persistence

Memory in Claude Code means context that persists across sessions. Unlike the conversation window which resets, memory files are loaded automatically every time Claude Code starts. This module explains the hierarchy of memory files, how to create and update them, and how auto memory works in the background.

## The Memory Hierarchy

Claude Code has two main memory systems: `CLAUDE.md` files that you write, and auto memory that Claude writes for itself. Officially documented `CLAUDE.md` locations are managed policy (org-wide), project instructions (`CLAUDE.md` or `.claude/CLAUDE.md`), user instructions (`~/.claude/CLAUDE.md`), and local instructions (`./CLAUDE.local.md` -- personal project-specific, gitignored).

Project memory is the one you'll use most. It's a markdown file committed to git and shared with your team. Put your tech stack, naming conventions, common commands, and non-obvious gotchas here. User memory is for personal preferences that apply across all your projects -- your preferred patterns, how you like code explained, tools you always use.

For larger projects, split instructions into `.claude/rules/*.md` files. Rules can be global to the project or scoped to paths with frontmatter. A rule with `paths: src/api/**/*.ts` only activates when Claude works with matching files:

```
---
paths: src/api/**/*.ts
---
All API endpoints must validate input with Zod. Return 400 with field-level errors on validation failure.
```

## Creating and Updating Memory

The fastest way to start is `/init`. Run it in your project directory and Claude analyzes the codebase to generate a starter `CLAUDE.md`. Use `CLAUDE_CODE_NEW_INIT=1 claude` for an interactive multi-phase setup flow.

For larger edits, `/memory` opens your memory files in your system editor. Make changes, save, and Claude reloads them automatically. If you want Claude to remember something automatically, ask it naturally, like "remember that the API tests require Redis." If you want it written into `CLAUDE.md`, ask Claude explicitly to add it there. The `@path/to/file` import syntax lets you reference existing documentation rather than duplicating it:

```
# Project Standards

@README.md
@docs/architecture.md
@package.json
```

Imports support up to five levels of nesting. First-time imports from external paths trigger an approval dialog.

## Auto Memory

Auto memory is a directory where Claude writes its own notes during sessions -- patterns it discovers, project-specific behaviors, debugging insights. The first 200 lines or 25KB of `~/.claude/projects/<project>/memory/MEMORY.md`, whichever comes first, load automatically at session start. Additional topic files (`debugging.md`, `api-conventions.md`) are loaded on demand.

You don't need to maintain auto memory manually; Claude handles writes itself. You can read and edit the files if you want to correct or add to Claude's notes. You can toggle it in `/memory`, disable it for a session with `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude`, or set `autoMemoryEnabled` in settings. To move the directory to a synced location or a custom path, set `autoMemoryDirectory` in user or local settings:

```json
{
  "autoMemoryEnabled": true,
  "autoMemoryDirectory": "/path/to/shared/memory"
}
```

In large monorepos with many `CLAUDE.md` files, use `claudeMdExcludes` in settings to skip irrelevant ones:

```json
{
  "claudeMdExcludes": ["packages/legacy-app/CLAUDE.md", "vendors/**/CLAUDE.md"]
}
```

Claude also loads `CLAUDE.md` files it finds above your current working directory, and it loads subdirectory `CLAUDE.md` files on demand when you work in those areas. In monorepos, `claudeMdExcludes` helps keep unrelated instructions out of context.
