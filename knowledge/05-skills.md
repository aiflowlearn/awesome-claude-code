# Skills

Skills are reusable capabilities that Claude discovers and uses automatically based on context. They're more powerful than simple commands: they support progressive loading to stay lightweight, dynamic shell context injection, subagent isolation, and invocation control. This module shows you how to design and build effective skills.

## How Skills Load

Claude keeps skill loading lightweight. Skill descriptions are loaded so Claude knows what capabilities are available. The full `SKILL.md` content loads only when the skill is invoked, and supporting files are read only when needed.

This means you can install many skills without flooding the context window. Claude knows they exist from their descriptions, then loads the actual instructions only for the skills it decides to use.

Skills live in `.claude/skills/<name>/SKILL.md` for project scope (committed to git) or `~/.claude/skills/<name>/SKILL.md` for personal scope. Plugin skills use a `plugin-name:skill-name` namespace, so they do not collide with project or personal skills. When non-plugin skills share the same name, the priority order is enterprise > personal > project.

Claude also auto-discovers skills from nested `.claude/skills/` directories in subdirectories of the project root. For example, if you're working inside `packages/frontend/`, Claude will also find skills defined in `packages/frontend/.claude/skills/`. This makes skills easy to co-locate with specific packages or services in monorepo setups.

```
.claude/skills/code-review/
├── SKILL.md          # Instructions (required)
├── templates/
│   └── review-checklist.md
└── scripts/
    └── analyze-metrics.py
```

## Writing Effective Skill Descriptions

The description field is the most important part of a skill. It controls when Claude auto-invokes the skill, and it must contain enough signal for Claude to match it against real user requests. A vague description like "helps with code" will never trigger. A specific description with concrete trigger terms works:

```yaml
---
name: security-review
description: Scan code for security vulnerabilities including injection flaws, authentication issues, and data exposure. Use when reviewing code changes, preparing a PR, or when the user mentions security, vulnerabilities, or audit.
---
```

Include the task type ("scan", "generate", "analyze"), the subject domain ("security", "API", "database"), and explicit trigger phrases ("when the user mentions", "use when"). The skill listing truncates each entry's combined `description` plus `when_to_use` text at 1,536 characters, so front-load the key use case and push overflow trigger phrases into `when_to_use`:

```yaml
---
name: security-review
description: Scan code for security vulnerabilities including injection flaws, authentication issues, and data exposure.
when_to_use: When reviewing code changes, preparing a PR, or when the user mentions security, vulnerabilities, or audit.
---
```

Claude budgets total skill description space at about 1% of the context window, with an 8,000-character fallback when needed, and `SLASH_COMMAND_TOOL_CHAR_BUDGET` lets you raise the cap. Run `/context` to check if skills are being excluded from the listing.

Supporting files extend the skill without inflating Level 2 context. Reference them from `SKILL.md` with relative paths:

`For the full review checklist, see [templates/review-checklist.md](templates/review-checklist.md).`

Claude reads supporting files with bash when it needs them. Keep `SKILL.md` under 500 lines; put detailed reference material in separate files.

## Dynamic Context and Invocation Control

The `!command` syntax executes shell commands before the skill content reaches Claude. The output is inlined -- Claude only sees the result, not the command. This is how you give skills live context:

```yaml
---
name: pr-summary
description: Summarize pull request changes. Use when asked to review or summarize a PR.
context: fork
agent: Explore
---
## PR context
- Diff: !`gh pr diff`
- Comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

Summarize the intent and key changes in this pull request.
```

The `shell` field specifies which shell to use for `!command` blocks. Set it to `powershell` instead of the default `bash` when working on Windows with the PowerShell tool enabled (`CLAUDE_CODE_USE_POWERSHELL_TOOL=1`):

```yaml
---
name: windows-helper
description: Manage Windows services and configurations
shell: powershell
---
```

Two frontmatter fields control who can invoke a skill. `disable-model-invocation: true` means only the user can invoke it via `/skill-name` -- Claude will never trigger it automatically. Use this for any skill with side effects (deploys, pushes, sends). `user-invocable: false` hides the skill from the `/` menu while still letting Claude auto-invoke it -- good for background knowledge skills that aren't actionable as commands.

`paths:` accepts a YAML list of globs that scope when a skill applies. When set, the skill only loads when the working directory matches one of the globs. This keeps project-specific skills from polluting unrelated sessions:

```yaml
---
name: api-generator
description: Generate REST API endpoints from schema definitions.
paths: ["src/**/*.ts", "tests/**"]
---
```

`effort` controls reasoning depth for the skill. Values are `low`, `medium`, `high`, `xhigh`, and `max` (session-only). Use `low` for quick lookups or boilerplate generation, `medium` for most tasks, and `high` for deep analysis that requires careful reasoning:

```yaml
---
name: security-review
description: Scan code for security vulnerabilities.
effort: high
---
```

`context: fork` runs the skill in an isolated subagent with its own context window. The `agent` field specifies which agent type: `Explore` for read-only research, `Plan` for planning, `general-purpose` for anything that needs all tools. The main conversation stays clean while the subagent does the heavy lifting.

The `model` field specifies which model to use when the skill is active. This is useful when a task benefits from a specific model's strengths (e.g., `opus` for complex reasoning, `sonnet` for fast execution):

```yaml
---
name: deep-analysis
description: Thoroughly analyze the codebase for a specific pattern or issue
context: fork
agent: Explore
model: opus
disable-model-invocation: true
---
Analyze $ARGUMENTS across the entire codebase:
1. Use Glob and Grep to find all occurrences
2. Read each file and understand context
3. Summarize patterns, inconsistencies, and recommendations
```

## Arguments and Tool Access

Skills accept arguments two ways. `$ARGUMENTS` captures everything after the command name as a single string. `$0`, `$1`, `$2` capture individual space-separated arguments. Both are substituted before the prompt reaches Claude. `argument-hint` improves the slash-menu autocomplete by showing what arguments a skill expects:

```yaml
---
name: review-pr
description: Review a GitHub PR by number
argument-hint: "<pr-number> <priority>"
allowed-tools: Bash(gh *), Read, Grep, Glob
---
Review PR #$0 with priority $1. Focus on security and performance.
Reference our standards in [standards/code-review.md](standards/code-review.md).
```

Usage: `/review-pr 456 high` -- `$0` becomes `456`, `$1` becomes `high`.

`allowed-tools` restricts which tools the skill can use when it runs, following the same pattern syntax as permission rules. This is useful for skills that should only read or only interact with specific CLI tools.

Legacy command files in `.claude/commands/*.md` still work but skills are the recommended format. If both exist with the same name, the skill takes priority.

## Built-in Skills

Claude Code ships with built-in skills that are always available without installation. `/less-permission-prompts` (new in v2.1.112) scans your conversation transcripts for common read-only Bash and MCP tool calls, then proposes a prioritized allowlist for your `.claude/settings.json`. Run it after a few sessions to generate a permission configuration tailored to your actual workflow:

`/less-permission-prompts`
