# Project Constitution for Claude Code

Reusable production CLAUDE.md template. Keep this file under 200 lines.

## Development Constitution

These rules have highest priority. Violations are incidents.

| # | Rule | Violation | Correct Practice |
|---|------|-----------|------------------|
| 1 | **Work on the agreed branch/worktree** | Creating unsynced branches or editing the wrong checkout | Confirm repo state before changes |
| 2 | **Verify before saying done** | Claiming completion from diff review only | Run the relevant command and provide real output |
| 3 | **Do reversible operations; ask before destructive ones** | Asking before cache cleanup, or deleting data without consent | Restart/clean cache yourself; ask for DB/deploy/data deletion |
| 4 | **Implement the full spec** | Stopping after coding without coverage check | Code, test, then verify each requirement |
| 5 | **Never commit production secrets** | Staging .env or credentials | Use examples and secret managers |
| 6 | **Check sensitive data before push** | Pushing tokens, passwords, private URLs | Scan staged diff and config files before push |

## Core Rules Table

| Area | Rule |
|------|------|
| API contracts | Frontend and backend field names must match |
| Configuration | Runtime values come from environment variables |
| Database | Use migrations; never reset production data without approval |
| Browser testing | Use isolated profiles; do not kill the user's main browser |
| Git | Inspect staged diff before commit |
| Reuse | Adapt existing modules before creating new abstractions |

## Verification SOP

Hard completion definition: implementation finished, real verification passed, evidence attached.

| Change Type | Verification | Pass Standard |
|-------------|--------------|---------------|
| API/backend | curl, integration test, or unit test | Correct status and data shape |
| Frontend logic | Browser test or component test | Critical interaction works |
| Visual UI | Screenshot or story preview | Matches intended layout |
| Config/data | Inspect effective value | Expected value is active |
| Refactor/rename | Build plus focused regression test | No behavior regression |

Do not say “small change, no verification needed.”

## Karpathy Four Principles

| # | Principle | Requirement |
|---|-----------|-------------|
| 1 | **Think Before Coding** | Ask when unclear; list interpretations; push back with simpler options |
| 2 | **Simplicity First** | Solve with the least code; avoid unrequested features |
| 3 | **Surgical Changes** | Only change what the task requires; do not opportunistically refactor |
| 4 | **Goal-Driven Execution** | Define success criteria and verification before implementation |

## Skill Routing

| Request Type | Suggested Skill/Workflow |
|--------------|--------------------------|
| Bug or regression | Systematic debugging/root-cause workflow |
| Browser QA | Manual browser verification or QA workflow |
| Code review | Diff review workflow |
| Shipping | Release/PR workflow |
| New feature design | Brainstorming and planning workflow |

## File Maintenance

This CLAUDE.md must stay under 200 lines. Move long explanations to docs/ and keep only enforceable rules here.
