# Setting Up Claude Code for a Project

Getting Claude Code working well on a project takes about ten minutes of setup. The payoff is that Claude understands your conventions from the first message, has the right permissions to do useful work, and behaves consistently for everyone on the team. This module walks through the setup steps in order.

## Initializing Project Memory

Start with `/init`. Claude scans your codebase -- reading `package.json`, existing docs, directory structure -- and generates a `CLAUDE.md` that captures your tech stack, key commands, and initial conventions. Commit this file to git immediately so teammates get the same context.

A good `CLAUDE.md` is concise and specific. Aim for under 200 lines per file. Every line should be relevant to nearly every session -- if something only matters for one feature, put it in a path-scoped rules file instead. The most valuable sections are: tech stack and versions, development commands (install, test, build, lint), naming conventions that aren't obvious, and known gotchas that would trip up a new developer.

```
# Project: Payment Service

## Stack

- Node.js 20, TypeScript 5, PostgreSQL 15
- Express for API, Prisma for ORM, Jest for tests

## Commands

- `npm run dev` -- start with hot reload
- `npm test` -- run test suite
- `npm run migrate` -- apply pending migrations
- `npm run lint` -- ESLint + Prettier check

## Conventions

- All monetary values stored as integers (cents)
- Use `Result<T, E>` pattern for error handling, never throw in service layer
- Database columns: snake_case; TypeScript: camelCase
```

## Configuring Permissions

Claude Code operates within a permission system that controls which tools it can use without asking. The default mode requires approval for most file writes and all bash commands. For active development, you'll want to pre-approve common operations.

Open the permission manager with `/permissions`. Add patterns for the commands Claude will use repeatedly. Use `Bash(git *)` to allow all git commands, `Bash(npm *)` for npm, or `Bash(npx jest *)` for a specific tool. File operations can be scoped to specific paths.

Settings files control permissions at project and user level. `.claude/settings.json` is committed to git for the team. `.claude/settings.local.json` is git-ignored for personal overrides:

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Read(**/*)",
      "Write(src/**/*)",
      "Edit(src/**/*)"
    ]
  }
}
```

For sensitive operations like production deploys, leave them requiring approval or use `disable-model-invocation: true` on skills so Claude can never trigger them automatically.

## Settings and Environment

Settings follow the official precedence model. From highest to lowest priority: managed settings, command-line arguments for the current session, `.claude/settings.local.json`, `.claude/settings.json`, and `~/.claude/settings.json`. Note that local settings (`.claude/settings.local.json`) override project settings -- personal preferences take precedence over team configuration, and only managed settings and command-line arguments override local. Managed delivery can use platform policy files or managed configuration directories, but those are implementation details for the top managed layer rather than separate everyday scopes.

Beyond permissions, useful settings include `env` for environment variables that should be present in every session, `agent` to set a custom default agent, and `claudeMdExcludes` for filtering out irrelevant memory files in monorepos. You can also set the default model and effort level:

```json
{
  "model": "claude-sonnet-4-6",
  "env": {
    "NODE_ENV": "development",
    "LOG_LEVEL": "debug"
  }
}
```

Add `.claude/settings.local.json` to your `.gitignore` so personal overrides stay personal. Share `.claude/settings.json`, `CLAUDE.md`, `.claude/rules/`, `.claude/skills/`, and optionally `.claude/agents/` with the team via git. That gives teammates the same shared project instructions and project-scoped extensions, while personal settings and auto memory remain local to each machine.
