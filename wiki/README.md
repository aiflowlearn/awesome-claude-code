# LLM Wiki Integration

Karpathy popularized the idea that LLMs work best with a living, structured knowledge base instead of scattered notes. An LLM Wiki turns raw sources into linked entities, concepts, and notes that Claude Code can query during development.

This repo includes example schemas and setup notes for using Claude Code with [llm-wiki-manager](https://github.com/sametbrr/llm-wiki-manager).

## Why It Complements Claude Code

- Claude Code handles the coding session.
- The llm wiki preserves durable project knowledge.
- Wiki pages reduce repeated context loading.
- Cross-references help Claude discover related concepts.
- Schemas keep generated knowledge consistent.

## Included Examples

- `wiki-schemas/learning-wiki.md` for course notes and learning paths.
- `wiki-schemas/project-wiki.md` for product and engineering docs.
- `wiki-schemas/research-wiki.md` for papers, articles, and technical research.
- `examples/sample-entity-page.md` showing an entity page for Claude Code.
