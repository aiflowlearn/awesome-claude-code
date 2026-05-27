# 实战任务 5.1: 用 Claude Code 创建 CLI TODO 工具

## 目标
综合运用前 4 个模块学到的知识，用 Claude Code 从零创建一个可运行的 CLI 工具。

## 操作

### 第一步：创建项目目录

```bash
mkdir -p ~/todo-cli && cd ~/todo-cli
```

### 第二步：启动 Claude Code 并提出需求

```bash
claude
```

输入以下需求：

```
帮我用 Node.js 创建一个 CLI TODO 工具，保存为当前目录下的 todo.js。要求：
1. 支持 add "任务内容" 添加任务
2. 支持 list 列出所有任务
3. 支持 done <id> 标记完成
4. 支持 delete <id> 删除任务
5. 数据存储在本地 JSON 文件中
6. 不使用任何外部依赖，只用 Node.js 内置模块
```

Claude 会为你创建 `todo.js` 文件。过程中它可能会请求确认，审查它的计划后批准。

### 第三步：退出 Claude Code

确认 Claude 已经创建好 `todo.js` 后，输入以下命令退出：

```
/exit
```

或者按 `Ctrl + C` 退出。

### 第四步：运行测试

退回到终端后，在 `~/todo-cli` 目录下运行以下命令验证工具是否正常工作：

```bash
node todo.js add "买菜"
node todo.js add "写代码"
node todo.js list
node todo.js done 1
node todo.js list
```

## 完成标准
所有命令正常执行，list 输出包含添加的任务。
