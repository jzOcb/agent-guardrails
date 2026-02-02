# Agent Guardrails — 中文文档

机械化执行工具，防止 AI 代理绕过已建立的项目标准。

## 快速开始

```bash
cd your-project/
bash /path/to/agent-guardrails/scripts/install.sh
```

安装 git pre-commit 钩子、创建注册表模板、复制检查脚本到项目中。

## 执行层级

1. **代码钩子**（git pre-commit、创建前/后检查）— 100% 可靠
2. **架构约束**（注册表、导入强制）— 95% 可靠
3. **自我验证循环**（代理检查自己的工作）— 80% 可靠
4. **提示规则**（AGENTS.md、系统提示）— 60-70% 可靠
5. **Markdown 规则** — 40-50% 可靠，随上下文长度衰减

## 提供的工具

### 脚本

| 脚本 | 使用时机 | 功能 |
|------|---------|------|
| `install.sh` | 每个项目一次 | 安装钩子和脚手架 |
| `pre-create-check.sh` | 创建新 `.py` 文件之前 | 列出现有模块/函数，防止重复实现 |
| `post-create-validate.sh` | 创建/编辑 `.py` 文件之后 | 检测重复、缺失导入、绕过模式 |
| `check-secrets.sh` | 提交前 / 按需 | 扫描硬编码的令牌、密钥、密码 |

### 资产

| 资产 | 用途 |
|------|------|
| `pre-commit-hook` | 即装即用的 git 钩子，阻止绕过模式和密钥泄露 |
| `registry-template.py` | 项目模块注册表的 `__init__.py` 模板 |

### 参考文档

| 文件 | 内容 |
|------|------|
| `enforcement-research.md` | 关于代码强制优于提示的研究 |
| `agents-md-template.md` | 带机械化执行规则的 AGENTS.md 模板 |

## 使用流程

### 设置新项目

```bash
bash scripts/install.sh /path/to/project
```

### 创建新 .py 文件之前

```bash
bash scripts/pre-create-check.sh /path/to/project
```

查看输出。如果现有函数满足需求，直接导入。

### 创建/编辑 .py 文件之后

```bash
bash scripts/post-create-validate.sh /path/to/new_file.py
```

在继续之前修复所有警告。

### 添加到 AGENTS.md

从 `references/agents-md-template.md` 复制模板并适配你的项目。

## 核心原则

> 不要添加更多 markdown 规则。添加机械化执行。
> 如果代理持续绕过某个标准，不要写更强的规则——写一个阻止它的钩子。
