# Set Up llm-wiki-manager with Claude Code

## 1. Install the Skill

Install the llm-wiki-manager skill from agentskills.io or the upstream repository instructions. Confirm Claude Code can see the skill in its available skills list.

## 2. Bootstrap a Wiki

Create a wiki directory in your project:

```bash
mkdir -p wiki/raw wiki/entities wiki/concepts wiki/notes
```

Copy one schema from this repo into your project CLAUDE.md or wiki instructions.

## 3. Ingest the First Source

Start with one high-signal source: a README, architecture doc, transcript, or API spec. Ask Claude Code to ingest it into raw notes first, then generate linked pages.

## 4. Query the Wiki

Use prompts like:

- “Search the llm wiki for auth-related entities before changing login.”
- “Summarize project constraints from wiki/concepts before planning.”
- “Update the entity page after this refactor.”

## 5. Keep It Current

Update the wiki after decisions, incidents, and major feature changes. Treat stale wiki pages like stale tests: useful only when maintained.
