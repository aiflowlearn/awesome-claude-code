# 实战任务 3.3: 创建 PostToolUse hook 自动格式化

## 目标
让 Claude 每次写文件后自动运行格式化工具。

## 操作
在 `.claude/settings.json` 中添加 hooks 配置：
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(echo \"$CLAUDE_TOOL_INPUT\" | python3 -c \"import sys,json; print(json.load(sys.stdin).get('file_path',''))\") && case \"$FILE\" in *.ts|*.tsx|*.js) npx prettier --write \"$FILE\" 2>/dev/null ;; *.py) python3 -m black \"$FILE\" 2>/dev/null ;; esac; exit 0"
          }
        ]
      }
    ]
  }
}
```

然后让 Claude 创建或修改一个文件，观察格式化是否自动触发。

## 完成标准
Claude 写文件后，代码被自动格式化。
