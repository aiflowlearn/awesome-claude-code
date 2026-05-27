# Model Context Protocol (MCP)

Connect Claude to external services, databases, and APIs using the Model Context Protocol.

MCP (Model Context Protocol) gives Claude real-time access to external services. Unlike memory files that store static context, MCP connections let Claude query live data — your GitHub issues, production database, Slack channels, or any service with an MCP server. This module covers adding servers, understanding scopes, and using MCP tools effectively.

## Adding MCP Servers

The fastest way to add a server is the `claude mcp add` command. Choose the transport that matches the server type: `http` for remote servers, `stdio` for locally-running processes, and `sse` for older remote servers that haven't moved to HTTP yet. _(Note: SSE is deprecated — use HTTP servers instead, where available.)_ On native Windows you'll often use `cmd /c` when launching `npx`-based stdio servers.

```
# Add a remote HTTP server
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Add a local Node.js server via stdio
claude mcp add --transport stdio github -- npx @modelcontextprotocol/server-github

# Add with an auth header
claude mcp add --transport http my-api https://api.example.com/mcp \
  --header "Authorization: Bearer $MY_TOKEN"
```

Manage your servers with `claude mcp list`, `claude mcp get <name>`, and `claude mcp remove <name>`. The `/mcp` command inside a session shows active connections and triggers OAuth flows for servers that require browser-based authentication. Other useful commands include `claude mcp reset-project-choices`, `claude mcp add-from-claude-desktop`, and `claude mcp serve` when you want Claude Code itself to act as an MCP server.

MCP configurations live in `~/.claude.json` (your local user config) or `.mcp.json` in the project root (shared with the team). The `.mcp.json` file is checked into git and prompts teammates for approval on first use. Environment variable expansion works in all configuration fields — use `${VAR:-default}` for fallbacks:

```
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

MCP connectors configured in Claude.ai can also appear automatically in Claude Code. If you set up a server through the web interface, it becomes available in your CLI sessions without separate local configuration. When the same server is configured both locally and via Claude.ai, duplicates are automatically deduplicated so you don't end up with two connections to the same service.

MCP configurations have three scopes. Local scope (stored in `~/.claude.json` under your project's key) is private — just you, just this project. Project scope (`.mcp.json`) is shared with the team via git. User scope (`~/.claude.json` globally) applies across all your projects.

When the same server is defined at multiple scopes, the local configuration wins. This lets you override a team-wide server config with a local version for testing without affecting anyone else.

MCP prompts appear as slash commands using the pattern `/mcp__servername__promptname`. MCP resources can be referenced inline with `@server:protocol://resource/path`. Tool Search is enabled by default — MCP tools are deferred and discovered on demand, so only the tools Claude actually uses for a task enter context. Individual MCP tool descriptions and server instructions are each capped at 2KB to prevent any single server from consuming excessive context.

Subagent-scoped MCP lets you give specific agents access to servers that the rest of the session doesn't need:

```
---
name: data-analyst
description: Analyze production data
mcpServers:
  - database
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
---
```

## Practical Usage Patterns

With the GitHub MCP connected, you can work with PRs, issues, and commits using natural language. Claude queries the server, gets live data, and responds:

```
List all open PRs that haven't been reviewed in more than 3 days.
Create an issue for the login timeout bug with medium priority.
/mcp__github__pr_review 456
```

The database MCP enables natural language queries without writing SQL yourself:

```
Find all users who placed more than 5 orders in the last 30 days.
What's the average order value by country for Q1 2026?
```

For complex workflows, multiple MCP servers compose naturally. A daily report workflow might: fetch PR metrics from GitHub MCP, query sales data from the database MCP, write a report using the filesystem MCP, and post it via Slack MCP — all in a single session.

MCP elicitation lets a server pause the workflow and request structured input from the user. When a server needs information it can't get on its own — an OAuth authorization, a confirmation before a destructive action, or a form with project-specific parameters — it triggers an interactive dialog. The user sees form fields or a browser URL, provides the response, and the server resumes where it left off. The `Elicitation` and `ElicitationResult` hooks let you intercept or customize these dialogs programmatically.

Security best practices: always use environment variables for credentials, never commit tokens to git, use read-only tokens when you only need to query data, and limit server access scope to the minimum needed. For enterprise deployments, `managed-mcp.json` lets administrators enforce an allowlist of permitted servers organization-wide.

Other important MCP capabilities worth knowing: tool lists can update dynamically when servers announce changes, and large MCP outputs are capped to avoid blowing up context.
