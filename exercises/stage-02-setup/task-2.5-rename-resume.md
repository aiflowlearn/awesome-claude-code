# 实战任务 2.5: 用 /rename + /resume 管理会话

## 目标
保存当前会话并在之后恢复。

## 操作
为当前会话命名：
```
/rename my-feature
```

退出 Claude Code（Ctrl+C 或输入 `/exit`），然后恢复会话：
```
claude --resume my-feature
```
或者在新的 Claude Code 会话中输入：
```
/resume my-feature
```

## 完成标准
恢复后的会话保留了之前的完整上下文。理解会话可以跨时间恢复，不需要从头开始。
