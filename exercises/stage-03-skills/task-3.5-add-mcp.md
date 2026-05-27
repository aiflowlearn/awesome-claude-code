# 实战任务 3.5: 添加 MCP server

## 目标
连接外部服务，让 Claude 实时获取数据。

## 操作
在终端中执行（不是在 Claude Code 会话内）：
```bash
claude mcp add --transport stdio github -- npx @modelcontextprotocol/server-github
```

验证连接：
```bash
claude mcp list
```

## 完成标准
`claude mcp list` 显示 github server。理解 MCP 让 Claude 连接外部服务获取实时数据。
