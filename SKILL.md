---
name: agent-guardrails
description: "Mechanical enforcement tools to prevent AI agents from bypassing established project standards. Use when setting up a new project workspace, configuring agent rules, or when an agent keeps rewriting existing validated code instead of importing it. Provides git hooks, pre/post-creation checks, secret detection, and registry templates. Reliability ranking from best to worst - code hooks, architectural constraints, self-verification, prompt rules, markdown."
---

# Agent Guardrails

Mechanical enforcement for AI agent project standards. Rules in markdown are suggestions. Code hooks are laws.

## Quick Start

```bash
cd your-project/
bash /path/to/agent-guardrails/scripts/install.sh
```

This installs the git pre-commit hook, creates a registry template, and copies check scripts into your project.

## Enforcement Hierarchy

1. **Code hooks** (git pre-commit, pre/post-creation checks) — 100% reliable
2. **Architectural constraints** (registries, import enforcement) — 95% reliable
3. **Self-verification loops** (agent checks own work) — 80% reliable
4. **Prompt rules** (AGENTS.md, system prompts) — 60-70% reliable
5. **Markdown rules** — 40-50% reliable, degrades with context length

## Tools Provided

### Scripts

| Script | When to Run | What It Does |
|--------|------------|--------------|
| `install.sh` | Once per project | Installs hooks and scaffolding |
| `pre-create-check.sh` | Before creating new `.py` files | Lists existing modules/functions to prevent reimplementation |
| `post-create-validate.sh` | After creating/editing `.py` files | Detects duplicates, missing imports, bypass patterns |
| `check-secrets.sh` | Before commits / on demand | Scans for hardcoded tokens, keys, passwords |

### Assets

| Asset | Purpose |
|-------|---------|
| `pre-commit-hook` | Ready-to-install git hook blocking bypass patterns and secrets |
| `registry-template.py` | Template `__init__.py` for project module registries |

### References

| File | Contents |
|------|----------|
| `enforcement-research.md` | Research on why code > prompts for enforcement |
| `agents-md-template.md` | Template AGENTS.md with mechanical enforcement rules |
| `SKILL_CN.md` | Chinese translation of this document |

## Usage Workflow

### Setting up a new project

```bash
bash scripts/install.sh /path/to/project
```

### Before creating any new .py file

```bash
bash scripts/pre-create-check.sh /path/to/project
```

Review the output. If existing functions cover your needs, import them.

### After creating/editing a .py file

```bash
bash scripts/post-create-validate.sh /path/to/new_file.py
```

Fix any warnings before proceeding.

### Adding to AGENTS.md

Copy the template from `references/agents-md-template.md` and adapt to your project.

## 中文文档 / Chinese Documentation

See `references/SKILL_CN.md` for the full Chinese translation of this skill.

## Key Principle

> Don't add more markdown rules. Add mechanical enforcement.
> If an agent keeps bypassing a standard, don't write a stronger rule — write a hook that blocks it.
