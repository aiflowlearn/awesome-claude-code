# 实战任务 4.2: 用 subagent 做 code review

## 目标
让专门的 agent 执行代码审查。

## 操作
在 Claude Code 中输入：
```
用 security-reviewer agent 审查 src/auth.ts（如果文件不存在，审查项目中任何涉及认证的代码）
```

## 完成标准
security-reviewer agent 输出审查报告，包含 severity、location 和 fix 建议。理解 subagent 用隔离上下文执行专项任务。
