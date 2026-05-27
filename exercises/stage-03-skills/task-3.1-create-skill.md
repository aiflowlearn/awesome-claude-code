# 实战任务 3.1: 创建自定义 skill

## 目标
创建一个可复用的 code review skill。

## 操作
在项目中创建目录和文件：
```bash
mkdir -p .claude/skills/review
```

创建 `.claude/skills/review/SKILL.md`：
```yaml
---
name: review
description: Review code changes for quality, security, and best practices. Use when the user mentions review, code quality, or audit.
---

Review the following code changes. Focus on:
1. Security vulnerabilities
2. Code quality and readability
3. Best practices for the project's tech stack

For each finding, provide: severity, location, description, and a concrete fix.
```

## 完成标准
在 Claude Code 中输入 `/`，命令列表中出现 `/review`。
