# 实战任务 2.1: 配置 /permissions

## 目标
预授权常用操作，减少重复确认。

## 操作
在 Claude Code 提示符中输入：
```
/permissions
```

添加以下权限规则：
- `Bash(git *)` — 允许所有 git 命令
- `Bash(npm *)` — 允许所有 npm 命令
- `Read(**/*)` — 允许读取所有文件

## 完成标准
`.claude/settings.json` 文件中包含 permissions.allow 规则。之后执行 git 和 npm 命令不再逐次确认。
