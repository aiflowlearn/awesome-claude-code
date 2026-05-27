# 实战任务 5.2: 用 /plan 规划后执行

## 目标
用 Planning mode 为已有的 TODO 工具规划新功能。

## 操作
在上一任务的 TODO 工具项目中，输入：

```
/plan 给 TODO 工具添加优先级和截止日期功能
```

Claude 会先研究现有代码，然后输出实施计划。审查计划内容：

- 是否与现有代码结构兼容
- 是否保留了已实现的功能
- 是否有合理的测试方案

确认计划后让 Claude 执行。

## 完成标准
Claude 先输出计划等你确认，确认后执行。完成后可以运行：

```bash
node index.js add "紧急会议" --priority high --due 2026-05-30
node index.js list
```

新功能正常工作。
