# Context Management for Claude Code

Context quality decides output quality. Give Claude Code enough information to act, but not so much that the important signal is buried.

## What to Provide

| Situation | Best Context |
|-----------|--------------|
| New feature | README, relevant directory tree, product requirement |
| Bug report | Steps to reproduce, exact error log, expected behavior |
| Refactor | Current boundary, target boundary, files that must not change |
| API integration | Request/response examples and auth assumptions |
| UI change | Screenshot, component path, design constraints |
| Test failure | Full failing command and first relevant stack trace |

## README vs Error Log vs Directory Structure

Use a README when the AI needs project conventions.

Use an error log when the failure is concrete. Include the command, environment, and complete stack trace around the first failure.

Use a directory structure when the AI must find where something belongs. Keep it shallow unless the naming is ambiguous.

## Context Budget

- Start with the smallest complete slice.
- Prefer file paths over pasted files when Claude Code can read locally.
- Paste external API docs only for the endpoints you need.
- Remove stale assumptions after the AI inspects the repo.

## Good Context Packet

```
Task: Fix the login redirect loop.
Files likely involved: apps/web/auth/*, apps/api/session/*
Repro: visit /dashboard while logged out, sign in, redirected to /login again.
Expected: land on /dashboard.
Latest error: [paste exact browser console or server log]
Verification: browser flow from logged-out state.
```

## Keep Context Fresh

If the AI changes code, future prompts should reference the new behavior, not the old plan. Ask for a summary before pausing a long session.
