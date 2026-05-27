# Task Decomposition for AI Coding

Good Claude Code tasks are small, testable, and have one intent. Treat each prompt like a work order, not a wish list.

## Rules of Thumb

- Keep each task under 30 minutes of focused work.
- Use one intent per prompt: fix one bug, add one component, refactor one boundary.
- Include the success condition before asking for implementation.
- Separate discovery, design, implementation, and verification when the problem is uncertain.
- Avoid mixing formatting, feature work, and bug fixes in one request.

## Good Task Shape

```
Goal: Add empty-state UI to the projects page.
Context: The API returns [] when the user has no projects.
Constraints: Reuse the existing Card and Button components.
Verification: Open /projects with an empty fixture and confirm the CTA appears.
```

## When to Split

Split the task if it requires:

1. Reading more than three subsystems.
2. Schema changes plus UI changes plus deployment work.
3. A design decision the AI cannot infer safely.
4. Multiple unrelated files with different owners.
5. More than one verification method.

## Prompt Patterns

- “First inspect and propose a plan; do not edit yet.”
- “Implement only step 2 from this plan.”
- “Verify with the existing test command and report real output.”
- “Stop and ask if you find a conflicting contract.”

## Anti-Patterns

- “Make the app better.”
- “Fix all bugs.”
- “Refactor this and add the new feature.”
- “Do whatever is needed.”

Small tasks make Claude Code faster, safer, and easier to review.
