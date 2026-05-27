# Claude Code 学习工具箱

> 一套完整的 Claude Code 学习工具箱：知识库、CLAUDE.md 模板、hooks、练习和 LLM Wiki 集成

[English](README.md) | 中文

## 为什么不是另一个 Awesome List

已经有 40,000+ stars 的 awesome list 在收集链接。本仓库不同：它提供可以直接复制使用的**工作代码和学习材料**。

- 12 篇覆盖 Claude Code v2.1.x 的系统知识文档
- 面向不同项目类型的 CLAUDE.md template
- 可运行的 claude code hooks，用于自动提醒代码审查和验证
- 28 个有明确目标的动手练习
- 面向长期知识管理的 llm wiki 集成

如果你在找 claude code tutorial、claude code configuration、claude code MCP、claude code skills、claude code best practices，或者想比较 claude code vs cursor，这里是实践入口。

## 快速开始

```bash
# 使用 CLAUDE.md 模板
cp templates/claude-md/minimal.md YOUR_PROJECT/CLAUDE.md

# 使用 hook
cp templates/hooks/stop-review-check.sh ~/.claude/hooks/

# 开始练习
cd exercises/stage-01-meet && cat *.md
```

## 知识库

| # | 主题 | 你会学到什么 |
|---|------|--------------|
| 00 | 入门 | 安装、登录、IDE 扩展、第一次会话 |
| 01 | Slash Commands | 内置命令参考 |
| 02 | Memory (CLAUDE.md) | 层级、自动记忆、claudeMdExcludes |
| 03 | 项目设置 | /init、权限、settings 优先级 |
| 04 | 命令深潜 | 上下文、会话、fast mode |
| 05 | Skills | Skill 创建、动态上下文、参数 |
| 06 | Hooks | PreToolUse/PostToolUse 模式 |
| 07 | MCP | MCP server、作用域、安全实践 |
| 08 | Subagents | 创建 subagent、链式调用、隔离 |
| 09 | 高级功能 | Planning mode、auto mode、sandboxing |
| 10 | 工作流 | CI/CD、cron、/batch |
| 11 | Plugins | 插件架构、市场 |

## 模板

| 模板 | 用途 |
|------|------|
| `templates/claude-md/minimal.md` | 来自配置包的最小 CLAUDE.md 模板 |
| `templates/claude-md/production.md` | 带验证 SOP 的生产级宪法模板 |
| `templates/claude-md/frontend.md` | 组件库、样式和状态管理 |
| `templates/claude-md/backend.md` | API、数据库和错误处理 |
| `templates/claude-md/fullstack.md` | Monorepo 全栈项目 |
| `templates/settings/settings.example.json` | Claude Code settings 示例 |
| `templates/commands/*.md` | 可复用 slash command 模板 |

## Hooks

- `stop-review-check.sh`：在停止前提醒 agent 审查和验证。
- `workflow-reminder.sh`：提醒 Claude Code 遵守更安全的工作流。

这些 claude code hooks 使用 MIT 协议，可以复制到自己的项目中。

## LLM Wiki 集成

`wiki/` 目录展示如何把 Claude Code 与 Karpathy 提倡的 llm wiki 模式、`llm-wiki-manager` 结合，把原始笔记、文档、访谈和决策沉淀成可长期复用的 claude code knowledge base。

## 练习（28 个动手任务）

| 阶段 | 目录 | 重点 | 任务数 |
|------|------|------|--------|
| 01 | `exercises/stage-01-meet/` | 认识 Claude Code | 7 |
| 02 | `exercises/stage-02-setup/` | 项目设置和 CLAUDE.md | 7 |
| 03 | `exercises/stage-03-skills/` | Skills 与自动化 | 6 |
| 04 | `exercises/stage-04-advanced/` | 阅读和修改代码 | 5 |
| 05 | `exercises/stage-05-build/` | 构建 CLI 工具 | 3 |

## FAQ

### 和 awesome list 有什么不同？

Awesome list 主要收集链接。本 claude code toolkit 提供可复制的模板、hooks、练习和知识文件。

### 如何使用 CLAUDE.md 模板？

从 `templates/claude-md/` 复制一个文件到项目根目录并命名为 `CLAUDE.md`，再按项目实际情况修改规则。

### 应该从哪个模板开始？

小项目用 `minimal.md`，严肃项目用 `production.md`，前端、后端、全栈项目使用对应领域模板。

### 什么是 LLM Wiki？

LLM Wiki 是一种结构化知识库，把原始资料整理成互相链接的实体、概念和笔记，方便 AI agent 查询。

### 是否覆盖 claude code MCP？

覆盖。知识库包含 MCP server 设置、作用域和安全实践。

### 是否覆盖 claude code skills？

覆盖。Skills 章节讲解结构、动态上下文和参数，练习部分帮助你动手实践。

### hooks 可以商用吗？

可以。hooks、settings、commands 使用 MIT 协议；知识和练习内容使用 CC BY-NC-SA 4.0。

### Claude Code 是 best ai coding tool 2026 吗？

取决于工作流。Claude Code 的优势是仓库级上下文、终端工作流、hooks、skills、MCP 和可验证的自动化。

### Claude Code vs Cursor 怎么选？

Cursor 是 IDE-first；Claude Code 是 agentic、terminal-first。很多团队会同时使用：Cursor 用于交互式编辑，Claude Code 用于更大的仓库任务和自动化。

## 在线练习

你可以在 [Zero2Claude](https://zero2claude.aiflowlearn.net/) 的浏览器环境中练习这些任务，无需本地安装。

## 贡献

请查看 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 相关仓库

- [awesome-claude-code](https://github.com/aiflowlearn/awesome-claude-code) — 本仓库
- [zero2claude](https://github.com/aiflowlearn/zero2claude) — 从零学习 Claude Code
- [zero2codex](https://github.com/aiflowlearn/zero2codex) — 从零学习 Codex CLI
- [zero2cursor](https://github.com/aiflowlearn/zero2cursor) — 从零学习 Cursor IDE
- [zero2codewhale](https://github.com/aiflowlearn/zero2codewhale) — 从零学习 CodeWhale
- [ai-coding-skillpacks](https://github.com/aiflowlearn/ai-coding-skillpacks) — 21 条 AI 编程学习路径
- [9router-starter-kit](https://github.com/aiflowlearn/9router-starter-kit) — 5 分钟上手 AI 模型路由

## License

- 代码（hooks、settings、commands）：[MIT](LICENSE-MIT)
- 内容（knowledge、exercises、practices、wiki schemas、CLAUDE.md templates）：[CC BY-NC-SA 4.0](LICENSE-CC-BY-NC-SA)

---

*由 [AIFlowLearn](https://aiflowlearn.net) 赞助 — AI 原生学习平台*

**[AIFlowLearn / AI智流学社](https://aiflowlearn.net)** — 浏览器中的 AI 编程练习环境、交互式课程和技能包。

[Zero2Claude](https://zero2claude.aiflowlearn.net/) | [Zero2Codex](https://zero2codex.aiflowlearn.net/) | [全部 Skill Packs](https://aiflowlearn.net/skillpacks)
