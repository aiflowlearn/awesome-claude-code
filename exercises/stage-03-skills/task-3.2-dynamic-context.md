# 实战任务 3.2: 用 !command 注入动态上下文

## 目标
让 skill 在调用时获取实时的 git diff 数据。

## 操作
编辑 `.claude/skills/review/SKILL.md`，添加动态上下文：
```yaml
---
name: review
description: Review code changes for quality and security.
---

## PR 上下文
- Diff: !`git diff HEAD`
- Changed files: !`git diff --name-only`

Review these changes. For each finding, provide: severity, location, description, and fix.
```

调用这个 skill：
```
/review
```

## 完成标准
调用 `/review` 时，Claude 能读取到当前的 git diff 输出作为 review 上下文。
