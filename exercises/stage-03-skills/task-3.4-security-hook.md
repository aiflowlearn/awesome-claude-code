# 实战任务 3.4: 创建 PreToolUse hook 安全扫描

## 目标
拦截危险命令，防止误操作。

## 操作
在 `.claude/settings.json` 的 hooks 中添加 PreToolUse 配置：
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat) && COMMAND=$(echo \"$INPUT\" | python3 -c \"import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))\") && if echo \"$COMMAND\" | grep -qE 'rm -rf /|drop database|DROP TABLE'; then echo \"Blocked: dangerous command detected\" >&2; exit 2; fi; exit 0",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

尝试让 Claude 执行一个被拦截的命令（如 `rm -rf /tmp/test`），观察阻断效果。

## 完成标准
执行危险命令时被 hook 拦截并阻断，Claude 显示错误消息。
