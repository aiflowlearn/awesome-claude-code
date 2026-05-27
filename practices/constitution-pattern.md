# The CLAUDE.md Constitution Pattern

A project CLAUDE.md is a constitution: short, enforceable rules that guide every Claude Code session. It is not a dumping ground for documentation.

## What Belongs in a Constitution

- Non-negotiable rules.
- Project-specific traps.
- Verification requirements.
- Tool and workflow routing.
- Security boundaries.
- File size or architecture constraints.

## Recommended Structure

1. Development constitution: 4-6 highest-priority rules.
2. Core rules table: project-specific conventions.
3. Verification SOP: how completion is proven.
4. Architecture map: only the directories needed to navigate.
5. Skill routing: which workflow to use for common requests.
6. Maintenance rule: keep the file under 200 lines.

## Writing Rules

- Write rules as observable behavior.
- Include the violation and the correct action.
- Remove generic advice that applies to every project.
- Link to docs for long explanations.
- Update the constitution after repeated mistakes.

## Example Rule

| Rule | Violation | Correct Practice |
|------|-----------|------------------|
| Verify before completion | Says “done” after editing files only | Run the relevant command and paste real output |

## What Not to Include

- Full API documentation.
- Long onboarding guides.
- Temporary plans.
- Personal preferences that do not affect correctness.
- Secrets, tokens, or production credentials.

## Maintenance Cadence

Review CLAUDE.md after every incident or confusing AI session. If a mistake repeats twice, encode the prevention rule. If a rule no longer matters, delete it.
