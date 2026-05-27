# 实战任务 4.4: 用 /sandbox 隔离运行

## 目标
启用沙箱模式，限制 Claude 的文件和网络访问。

## 操作
在 Claude Code 中输入：
```
/sandbox
```

启用后，Claude 只能访问你批准的路径和网络规则。

配置沙箱规则（在 settings.json 中）：
```json
{
  "sandbox": {
    "enabled": true,
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

## 完成标准
沙箱模式启用。理解沙箱适合在不受信任的代码上运行 Claude，或需要严格边界的场景。
