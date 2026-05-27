# Plugins

Build and distribute plugins that bundle skills, agents, hooks, MCP servers, and LSP support into installable packages.

Plugins are the highest-level extension mechanism in Claude Code. They bundle skills, subagents, hooks, MCP servers, and LSP configurations into a single installable package. A team installs one plugin and immediately gets everything configured — no manual setup for each component. This module covers the plugin structure, manifest format, distribution mechanisms, and how to build your own.

## Plugin Architecture

A plugin is a directory with a specific structure. The only required file is `.claude-plugin/plugin.json`, the manifest that declares the plugin's identity. Everything else is optional but follows conventions Claude Code recognizes:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json       # Required manifest
├── skills/               # SKILL.md files
│   └── my-skill/
│       └── SKILL.md
├── agents/               # Subagent definitions
│   └── specialist.md
├── commands/             # Legacy command files (also work)
│   └── my-command.md
├── hooks/
│   └── hooks.json        # Plugin-scoped hooks
├── .mcp.json             # MCP server configs
├── .lsp.json             # LSP server configs
├── settings.json         # Default settings
└── bin/
    └── helper.sh
```

The manifest identifies the plugin and its metadata:

```
{
  "name": "pr-review",
  "description": "Complete PR review workflow with security and test coverage checks",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/you/pr-review",
  "license": "MIT"
}
```

Plugin commands and plugin-provided skills are namespaced as `plugin-name:command-name` to avoid conflicts with project-level configuration. Invoke them with the full namespaced form, such as `/pr-review:check-security`.

## Manifest Features

The manifest supports several powerful fields for configuring plugin behavior. `userConfig` declares user-configurable options. Fields marked `sensitive: true` are stored in the system keychain rather than plain-text settings:

```
{
  "name": "my-plugin",
  "version": "1.0.0",
  "userConfig": {
    "apiKey": {
      "description": "API key for the integration",
      "sensitive": true
    },
    "region": {
      "description": "Deployment region",
      "default": "us-east-1"
    }
  }
}
```

Plugins get a persistent data directory via `${CLAUDE_PLUGIN_DATA}` (v2.1.78+). This survives across sessions, making it suitable for caches, state files, and databases. Use `${CLAUDE_PLUGIN_ROOT}` to reference paths relative to the plugin installation directory — essential for hooks and MCP configurations:

```
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node ${CLAUDE_PLUGIN_ROOT}/bin/audit.js"
          }
        ]
      }
    ]
  }
}
```

LSP support adds real-time language server protocol integration. Put a `.lsp.json` in the plugin root to configure language servers that provide instant diagnostics, go-to-definition, and symbol search as Claude edits files:

```
{
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact"
    }
  }
}
```

## Distribution and Development

Test a plugin locally with the `--plugin-dir` flag before distributing. It loads the plugin for that session only — no installation:

```
claude --plugin-dir ./my-plugin
# Test multiple plugins simultaneously:
claude --plugin-dir ./my-plugin --plugin-dir ./another-plugin
```

Use `/reload-plugins` to hot-reload plugin files during development without restarting the session. This re-reads all manifests, skills, agents, hooks, and MCP configurations instantly.

Plugin distribution follows a marketplace model. The official Anthropic marketplace is `claude-plugins-official`. Add additional marketplaces with `/plugin marketplace add owner/repo-name`. Install plugins with `/plugin install plugin-name` or `claude plugin install plugin-name@marketplace`:

```
# Install from official marketplace
/plugin install pr-review

# Install from GitHub
/plugin install github:username/my-plugin

# Install from local path (for testing)
/plugin install ./path/to/plugin
```

For enterprise environments, `managed-mcp.json` controls which MCP servers plugins can use. The `deniedPlugins`, `enabledPlugins`, `extraKnownMarketplaces`, and `strictKnownMarketplaces` settings in managed policy control which plugins and marketplaces are allowed organization-wide. Plugin subagents have restricted frontmatter — they cannot define `hooks`, `mcpServers`, or `permissionMode` to prevent privilege escalation.

Useful lifecycle commands include `claude plugin list`, `claude plugin enable`, `claude plugin disable`, `claude plugin uninstall`, and `claude plugin validate`. Marketplaces can source plugins from GitHub, git URLs, local paths, npm, or other supported package sources.

The inline plugin pattern (`source: 'settings'` in v2.1.80+) lets you embed a plugin definition directly in a settings file without a separate repository. This is useful for small team-internal tools that don't warrant a full git repository:

```
{
  "pluginMarketplaces": [
    {
      "name": "internal-tools",
      "source": "settings",
      "plugins": [
        {
          "name": "code-standards",
          "source": "./local-plugins/code-standards"
        }
      ]
    }
  ]
}
```
