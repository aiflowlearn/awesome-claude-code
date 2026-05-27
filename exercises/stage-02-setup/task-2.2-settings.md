# 实战任务 2.2: 编辑 settings.json

## 目标
通过配置文件设置默认模型和环境变量。

## 操作
创建或编辑 `.claude/settings.json`，添加：
```json
{
  "model": "claude-sonnet-4-6",
  "env": {
    "NODE_ENV": "development"
  }
}
```

在 Claude Code 中输入 `/config` 确认配置已加载。

## 完成标准
`/config` 显示新配置。理解 settings.json 的优先级：managed > 命令行 > settings.local.json > settings.json > 用户级 settings。
