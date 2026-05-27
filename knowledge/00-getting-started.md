# Getting Started

## What is Claude Code?

Claude Code is an **AI coding assistant** that lives in your **terminal** — the text-based window where developers type commands. Instead of clicking buttons in an app, you type what you want in plain English, and Claude reads your code, suggests fixes, writes new features, runs tests, and even manages files — all by understanding your project directly on your machine.

**New to the terminal?** — key terms explained:
* **Terminal** (also called console or command line): a text window where you type commands instead of clicking icons. On macOS it's called Terminal.app, on Windows it's Windows Terminal or PowerShell.
* **CLI** (Command Line Interface): a program you control by typing commands rather than using a graphical interface. Claude Code is a CLI tool.
* **Slash command**: a shortcut that starts with `/` (like `/help` or `/config`) that triggers a specific action inside Claude Code.
* **OAuth**: a secure sign-in method that opens your browser so you can log in without pasting passwords into the terminal.
* **API key**: a secret code that lets a program authenticate with a service. Used as an alternative to OAuth when connecting Claude Code.
* **IDE** (Integrated Development Environment): a code editor with built-in tools — VS Code, IntelliJ IDEA, and PyCharm are popular examples.

Before you can use any slash command or build a workflow, you need Claude Code running on your machine. This module walks you through installation, authentication, picking the right terminal and IDE setup, and running your very first session.

## Prerequisites

Claude Code runs on macOS 13+, Ubuntu 20.04+ (and other modern Linux distros), and Windows 10 1809+ (native or WSL). You need at least 4 GB of RAM — 8 GB is recommended for comfortable use. An active internet connection is required at all times.

You also need a paid Anthropic subscription. Claude Code is available on Claude Pro, Max, Team, Enterprise, and Console accounts. The free Claude.ai plan does not include Claude Code access. Alternatively, you can use an API key from the Anthropic Console or connect through Amazon Bedrock, Google Vertex AI, or Microsoft Foundry.

On Windows, Git for Windows is recommended so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead.

## Installing the CLI

The recommended way to install Claude Code is the native installer. It auto-updates in the background so you always have the latest version.

On macOS or Linux (including WSL):
```
curl -fsSL https://claude.ai/install.sh | bash
```

On Windows via PowerShell:
```
irm https://claude.ai/install.ps1 | iex
```

After installation, verify it worked:
```
claude --version
```

You can control the update channel through `/config` — choose between `latest` (newest features) and `stable` (tested releases).

## Authentication

When you run `claude` for the first time, it automatically opens your browser for OAuth authentication. Sign in with your Anthropic account and you're ready to go.

If you're using an API key instead, set the environment variable before launching:
```
export ANTHROPIC_API_KEY=sk-ant-...
claude
```

For enterprise or cloud provider setups, use the corresponding environment variables:
* **Amazon Bedrock**: `CLAUDE_CODE_USE_BEDROCK=1`
* **Google Vertex AI**: `CLAUDE_CODE_USE_VERTEX=1`
* **Microsoft Foundry**: `CLAUDE_CODE_USE_FOUNDRY=1`

Your credentials are stored securely — in the macOS Keychain on Mac, or in `~/.claude/.credentials.json` (mode 0600) on Linux and Windows.

To switch accounts or re-authenticate at any time, use `/logout`. You can also explicitly trigger authentication with `claude auth login`.

## IDE Extensions

Claude Code started as a CLI tool, but it now has official extensions for major editors. You can use both — the CLI for heavy terminal work and the extension for in-editor convenience.

**VS Code** is the most mature integration. Install it from the VS Code Marketplace or run `code --install-extension Anthropic.claude-code`. It gives you a native graphical interface, visual diff review, file references, conversation history, and the ability to run multiple conversations in tabs.

**JetBrains** has an official plugin in beta, available in the JetBrains Marketplace for IntelliJ IDEA, WebStorm, PyCharm, and other JetBrains IDEs.

Both **Cursor** and **Windsurf** (VS Code forks) also support Claude Code extensions.

## Your First Session

Navigate to any project directory and launch Claude Code:
```
cd my-project
claude
```

You'll see a welcome message and a prompt. Just type what you want Claude to do in plain English:

```
What files are in this project and what does it do?
```

Claude will read your files, analyze the structure, and give you a summary. From here, you can ask it to make changes, fix bugs, run tests, or explain code. When Claude needs to perform actions like editing files or running commands, it will ask for your permission first.

That's it — you're ready. Head to the next module to learn the slash commands that make Claude Code truly powerful.
