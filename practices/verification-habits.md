# Verification Habits for AI-Assisted Development

Do not trust generated code until it runs. Claude Code is powerful, but verification is the difference between a plausible patch and a working change.

## The Verification Loop

1. Reproduce the bug or define the expected behavior.
2. Make the smallest change that should affect it.
3. Run the relevant test, command, or browser flow.
4. Inspect real output.
5. Repeat until the evidence matches the goal.

## Match Verification to Change Type

| Change | Verification |
|--------|--------------|
| Backend endpoint | curl or integration test |
| UI interaction | Browser click path or Playwright test |
| Visual layout | Screenshot review |
| Config | Print or inspect effective config |
| Build tooling | Clean install/build command |
| Refactor | Existing tests plus one focused behavior check |

## Reproduce Before Fixing

For bugs, ask Claude Code to reproduce the issue first. A fix without reproduction often fixes the wrong thing.

Good prompt:

```
Investigate this failing checkout flow. First reproduce it and identify the root cause. Do not implement a fix until the cause is clear.
```

## Evidence to Ask For

- Command run.
- Exit status.
- Relevant output lines.
- Browser URL and visible result.
- Screenshot path when visual.

## Common Failure Modes

- Typecheck passes but browser flow fails.
- Unit test passes but database migration fails.
- Screenshot looks fine at desktop but breaks on mobile.
- Mocked API passes but real contract differs.

Make verification a habit, not a cleanup step.
