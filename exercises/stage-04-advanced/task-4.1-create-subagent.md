# 实战任务 4.1: 创建 subagent

## 目标
定义一个专门的 code review subagent。

## 操作
创建文件 `.claude/agents/security-reviewer.md`：
```yaml
---
name: security-reviewer
description: Security-focused code reviewer. Use proactively after writing authentication, authorization, or data handling code.
tools: Read, Grep, Glob
---

You are a senior security engineer specializing in application security.

Review priorities:
1. Authentication and authorization flaws
2. Injection vulnerabilities (SQL, XSS, command)
3. Data exposure and sensitive information handling

For each finding, provide: severity (Critical/High/Medium/Low), location (file:line), description, and a concrete fix.
```

验证文件已创建：
```bash
ls -la .claude/agents/security-reviewer.md
cat .claude/agents/security-reviewer.md
```

## 完成标准
`.claude/agents/security-reviewer.md` 文件存在且包含正确的 frontmatter（name、description、tools）。理解 Claude Code 的自定义 subagent 通过 `.claude/agents/*.md` 文件定义，Claude Code 在交互会话中会自动发现并可以使用这些 agent。每个 subagent 有自己的上下文窗口和工具权限。
