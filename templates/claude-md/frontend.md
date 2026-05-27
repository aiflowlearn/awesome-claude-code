# Frontend Project Constitution

## Development Constitution

| # | Rule | Correct Practice |
|---|------|------------------|
| 1 | Verify UI in a real browser | Use Playwright, Storybook, or screenshots before saying done |
| 2 | Components are small and composable | Prefer focused components under 200 lines |
| 3 | Styling is system-first | Use design tokens and shared primitives before custom CSS |
| 4 | State has one owner | Keep local, URL, server, and global state clearly separated |
| 5 | Accessibility is required | Labels, keyboard flow, focus states, contrast |
| 6 | No secrets in client code | Public env vars only; server secrets stay server-side |

## Component Library Rules

| Area | Rule |
|------|------|
| Primitives | Build from shared Button/Input/Card/Dialog primitives |
| Props | Prefer explicit props over configuration blobs |
| Composition | Use children/slots for layout flexibility |
| Files | One component intent per file; split before 200 lines |
| Stories | Add examples for important states: loading, empty, error, success |

## Styling Conventions

- Use tokens for color, spacing, radius, typography, and shadows.
- Avoid one-off pixel values unless matching a design artifact.
- Keep responsive behavior close to the component.
- Do not mix multiple styling systems in the same component.
- Prefer semantic class names or utility groups that describe intent.

## State Management Patterns

- Local state: transient UI state such as open/closed and input drafts.
- URL state: filters, pagination, and shareable view state.
- Server state: fetched data, cache invalidation, mutations.
- Global state: authenticated user, theme, app-wide preferences only.

## Verification SOP

| Change | Verify With |
|--------|-------------|
| Visual component | Screenshot or Storybook state |
| Interaction | Browser test or manual click path |
| Data fetching | Mock/error/loading states |
| Accessibility | Keyboard navigation and labels |

## Skill Routing

Use design review for visual changes, QA for user flows, and code review before landing major refactors.
