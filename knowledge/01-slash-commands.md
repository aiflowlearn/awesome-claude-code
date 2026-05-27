# Slash Commands

Slash commands are the fastest way to control Claude Code's behavior during an interactive session. Type `/` at any prompt to see the full list, or type a few letters to filter. This module covers the built-in commands you'll use every day.

## Discovering Commands

Type `/` at the prompt and a menu appears with all available commands. Start typing to filter -- `/co` narrows to `/compact`, `/color`, `/config`, `/context`, `/cost`, `/copy`. Arrow keys navigate, Enter selects. Commands that aren't available for your current setup are hidden automatically, so you only see what works.

New to Claude Code? Try `/powerup` -- it runs interactive lessons with animated demos that walk you through key features right inside the CLI.

Some commands accept arguments directly: `/compact focus on the API layer`, `/model opus`, `/effort high`, `/rename auth-refactor`. Others like `/context`, `/cost`, and `/status` run immediately with no arguments.

```
/compact focus on the payment service
```

## Command Categories

Built-in commands group into a few categories. Knowing the categories helps you find the right command without memorizing all of them.

**Context management** controls how much of the conversation Claude can see. `/context` shows a visual grid of your context usage. `/compact` compresses the conversation -- pass instructions to control what's preserved: `/compact keep the migration plan, drop the debugging`. `/clear` starts completely fresh.

**Session tools** let you manage and revisit work. `/rename my-feature` gives the session a readable name. `/resume` picks up a previous session. `/branch` creates a parallel conversation to explore an alternative without losing your current state. `/rewind` rolls back to an earlier point. `/export` saves the session to a file or clipboard.

**Configuration** commands adjust Claude's behavior mid-session. `/model` switches between available models such as Sonnet, Opus, Haiku, and other aliases like `best` or `opusplan`. `/effort` sets reasoning depth -- `low`, `medium`, `high`, `max`, or `auto`. `/permissions` manages what Claude can do without asking. `/config` opens the settings menu.

**Diagnostics** help when something isn't working. `/cost` shows session cost, duration, code changes, and token usage. `/status` shows version, model, and account info. `/doctor` checks installation health. `/diff` opens an interactive viewer for uncommitted changes -- useful for reviewing what Claude has done before committing.

```
/context
/compact keep the auth refactor plan
/model opus
/effort high
/cost
```
