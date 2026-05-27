# 实战任务 4.5: 用 claude -p 非交互运行

## 目标
在脚本和 CI/CD 中使用 Claude Code。

## 操作
在终端中执行（不是在 Claude Code 会话内）：
```bash
echo "请 review src/main.ts 的安全性" | claude -p "review this file for security issues" --output-format json
```

也可以用于批量操作：
```bash
claude -p "为 src/ 目录下所有公共函数添加 JSDoc 注释" --permission-mode bypassPermissions
```

## 完成标准
stdout 输出 Claude 的 review 结果（JSON 格式）。理解 claude -p 是 CI/CD 集成的基础，结合 --output-format json 可以结构化解析输出。
