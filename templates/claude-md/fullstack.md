# Fullstack Project Constitution

## Development Constitution

| # | Rule | Correct Practice |
|---|------|------------------|
| 1 | Verify end-to-end behavior | Test API plus browser flow before saying done |
| 2 | Contracts are shared | Keep frontend types aligned with backend responses |
| 3 | UI and data states are complete | Loading, empty, error, and success states exist |
| 4 | Database changes are reversible | Use migrations and backup plans |
| 5 | Secrets stay server-side | Client receives only public config |
| 6 | Keep changes surgical | One intent per prompt, one intent per PR |

## Monorepo Structure

```
project/
├── apps/
│   ├── web/          # frontend app
│   └── api/          # backend app
├── packages/
│   ├── ui/           # shared components
│   ├── config/       # lint/test/build config
│   └── contracts/    # shared schemas and types
├── docs/             # architecture and decisions
└── scripts/          # repeatable automation
```

## Frontend Rules

- Use shared UI primitives before creating custom components.
- Keep page components thin; move reusable behavior into hooks/modules.
- Represent loading, empty, error, and success states.
- Validate accessibility with keyboard navigation and labels.

## Backend Rules

- Validate all input at API boundaries.
- Use migrations for schema changes.
- Return stable response shapes and structured errors.
- Test authorization for both allowed and denied cases.

## Contract Rules

| Area | Rule |
|------|------|
| Schemas | Shared schema is source of truth when possible |
| Fields | Do not rename one side without updating the other |
| Errors | Frontend handles documented backend error codes |
| Tests | Add at least one integration path for critical flows |

## Verification SOP

Run typecheck/build, focused backend tests, and one browser flow for user-visible changes. Keep files under 200 lines where practical.
