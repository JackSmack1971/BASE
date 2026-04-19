# BASE 🧬

**The official Antigravity starter template** — pre-configured agent skills, strict guardrails, and battle-tested workflows for production-grade full-stack development.
[Official Antigravity page](https://antigravity.google) 
[DEEPMIND](https://deepmind.google/technologies/gemini/)
[](LICENSE) 

--- 

## ✨ What is BASE? BASE is the **foundational skill library and playbook** for Google Antigravity agents. It gives your AI coding agents:
- A consistent "Master Antigravity Integration Architect" persona
- Non-negotiable safety guardrails- Dozens of expert skills (Prisma, TDD, security, modern UI, Terraform, etc.)
- Reusable workflows for planning, migrations, PR reviews, and more- Moderate modularity and artifact-first execution Clone this repo into any new project (or fork it) and your Antigravity agents will immediately operate with professional structure, safety, and velocity. 

--- 

## 🚀 Quick Start 1. **Fork or clone** this repository into your new project: 

```
bash git clone https://github.com/JackSmack1971/BASE.git my-new-project cd my-new-project
```
2. **Open the project in Antigravity** (or Cursor/VS Code with Antigravity integration).
  
3. The agent will automatically discover:
  
  * `.agent/` (skills, rules, workflows)
  * `AGENTS.md` (master persona + routing)
  * `.antigravity-local.md` (local config)
4. Start chatting with your agent using commands like:
  
  * `/workflow plan-complex-task`
  * `Implement a new feature with TDD`
  * `Safe database migration`

* * *

## 📁 Project Structure

    BASE/
    ├── .agent/                  # ← Core agent intelligence
    │   ├── rules/               # Global & domain-specific rules
    │   ├── skills/              # Expert skill modules (Prisma, TDD, etc.)
    │   └── workflows/           # Reusable multi-step workflows
    ├── .gemini/antigravity/knowledge/   # Context & knowledge base
    ├── AGENTS.md                # Master playbook + guardrails (never exceed 1500 tokens)
    ├── .antigravity-local.md    # Local configuration
    └── README.md

* * *

## 🛡️ Non-Negotiable Guardrails (from AGENTS.md)

The Master Antigravity Integration Architect **always** follows these rules:

* Never write to `/migrations` without prior backup verification
* Never modify `.env` without surfacing a diff first
* Always declare file ownership before parallel execution
* Require an Implementation Plan Artifact before any destructive operation
* Never set `alwaysApply: true` on domain-specific skill files

* * *

## 🔥 Key Skills & Workflows

### Available Skills

* **db-migration** — PostgreSQL + Prisma safe migrations
* **tdd-enforcer** — Strict red-green-refactor enforcement
* **security-audit** — Auth, JWT, crypto, penetration patterns
* **frontend-verify** — Shadcn + Tailwind + Radix UI verification
* **refactor-legacy** — Multi-file AST dependency tracing
* **context-compact** — Session compaction & trajectory summarization
* **planning** — Persistent multi-session planning

### Available Workflows

* `plan-complex-task`
* `plan-status`
* Full-stack feature implementation
* Safe database migrations
* PR review & approval

* * *

## 🛠️ How to Extend

1. Add new skills in `.agent/skills/`
2. Add new rules in `.agent/rules/`
3. Add new workflows in `.agent/workflows/`
4. Update the **Routing Index** in `AGENTS.md`

All domain logic stays in the skill files — `AGENTS.md` remains the clean routing + guardrail index.

* * *

## 📜 License

MIT © JackSmack1971

* * *

## 🤝 Contributing

This is a living base template. Contributions that improve safety, add new high-value skills, or tighten workflows are welcome.

1. Fork the repo
2. Add your skill/workflow
3. Update `AGENTS.md` routing index
4. Open a PR

* * *

**Made for Antigravity • April 2026 Playbook**
