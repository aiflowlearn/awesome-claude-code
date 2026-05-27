# Backend Project Constitution

## Development Constitution

| # | Rule | Correct Practice |
|---|------|------------------|
| 1 | API contracts are explicit | Validate requests and document response shapes |
| 2 | Data changes use migrations | Never reset shared databases without written approval |
| 3 | Errors are structured | Return stable codes and safe messages |
| 4 | Auth boundaries are tested | Verify roles, ownership, and denied paths |
| 5 | Observability is built in | Log request IDs and actionable failure context |
| 6 | Secrets never enter git | Use env vars and example config only |

## API Patterns

| Area | Rule |
|------|------|
| Routes | Resource-oriented names and predictable verbs |
| Validation | Validate at the boundary before business logic |
| Responses | Stable envelope or documented shape; no surprise fields |
| Pagination | Cursor or page metadata for list endpoints |
| Idempotency | Required for retries, payments, and external callbacks |

## Database Rules

- Create migrations for schema changes.
- Backfill data with reviewed scripts and rollback notes.
- Add indexes with query patterns in mind.
- Do not hide database errors behind generic success responses.
- Never log credentials, tokens, or full personal data.

## Error Handling Conventions

- Client errors: 4xx with safe, actionable messages.
- Server errors: 5xx with internal logs and request ID.
- External service failures: timeout, retry policy, and fallback behavior.
- Validation failures: field-level details when safe.

## Verification SOP

| Change | Verify With |
|--------|-------------|
| Endpoint | curl or integration test |
| Auth rule | Allowed and denied test cases |
| Migration | Apply on clean database and existing fixture |
| Background job | Run job locally with representative input |

Keep backend files focused; split before 200 lines when responsibilities diverge.
