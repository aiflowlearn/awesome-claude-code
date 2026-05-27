# 实战任务 1.1: 验证 Claude Code 环境

## 目标
确认 Claude Code 已安装并可正常使用。

## 前置条件
如果你的环境还没有 Claude Code，需要先安装并配置认证。以下提供两种方式：

**安装方式（任选其一）：**

官方安装脚本（macOS / Linux）：
```bash
curl -fsSL https://claude.ai/install.sh | bash
```
Windows (PowerShell)：
```powershell
irm https://claude.ai/install.ps1 | iex
```
npm 全局安装（适合 Docker / 已有 Node 的环境）：
```bash
npm install -g @anthropic-ai/claude-code
```

**认证方式（任选其一）：**

方式一：浏览器登录（推荐，需 Anthropic 付费订阅）：
```bash
claude auth login
```

方式二：API Key 环境变量（适合企业代理或第三方 API）：
```bash
export ANTHROPIC_AUTH_TOKEN=你的API密钥
export ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
export ANTHROPIC_MODEL=glm-4-flash
```

> 本课程学习环境已预装 Claude Code 并配置好认证，可直接进行下方操作。

## 操作
验证安装：
```bash
claude --version
```

验证模型响应：
```bash
claude -p "hello world" --output-format text
```

## 完成标准
`claude --version` 输出版本号，`claude -p "hello world"` 正常返回文本回复。
