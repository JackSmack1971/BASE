# BASE 🧬

**The official Antigravity starter template** — pre-configured agent skills, strict guardrails, and battle-tested workflows for production-grade full-stack development.

[![Antigravity](https://img.shields.io/badge/Antigravity-Enabled-8B5CF6)](https://antigravity.google) 
[![Gemini](https://img.shields.io/badge/Powered%20by-Gemini-4285F4)](https://deepmind.google/technologies/gemini/)
[![GStack](https://img.shields.io/badge/GStack%20Integrated-Phase%202-00D4FF)](https://github.com/garrytan/gstack)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## ✨ What is BASE?

BASE is the **foundational skill library and playbook** for Google Antigravity agents.

It gives your AI coding agents:
- A consistent "Master Antigravity Integration Architect" persona
- **Non-negotiable safety guardrails**
- Dozens of expert skills (Prisma, TDD, security, modern UI, Terraform, etc.)
- **GStack-powered Continuous Checkpoints** (mandatory trajectory persistence)
- **Taste Engine** + **Anti-Slop Guard** (opt-in advanced personalization & quality)

Clone this repo into any new project (or fork it) and your Antigravity agents will immediately operate with professional structure, extreme safety, and high-velocity design intelligence.

---

## 🚀 Quick Start

1. **Fork or clone** this repository:
   ```bash
   git clone https://github.com/JackSmack1971/BASE.git my-new-project
   cd my-new-project
   ```

2. **Open in Antigravity** (or Cursor/VS Code with Antigravity).

3. **Start using the new GStack features**:
   - `context-save [message]` — manual checkpoint
   - `checkpoint-status` — see trajectory health
   - (Opt-in) Enable Taste Engine & Anti-Slop in `.antigravity-local.md`

---

## 🛡️ Core Safety (Mandatory)

### Continuous Checkpoints — Never lose hours of work again
Automatically saves mental model + Git patch before any destructive operation.

- **Commands**: `context-save [msg]`, `context-restore [id|latest]`, `checkpoint-status`
- **Storage**: Local `.agents/checkpoints/` + hidden `checkpoint/*` branch
- **Enforced** in every session via `_master.md`

---

## 🎨 Advanced Intelligence (Opt-in)

### Taste Engine
Learns your personal aesthetic preferences (fonts, colors, layout density, design style) across sessions.

- **Enable**: `enable_taste_engine: true` in `.antigravity-local.md`
- **Commands**: `synchronize-taste approve/reject …`, `apply-style-tokens`

### Anti-Slop Guard
Automatically flags and prevents generic AI design patterns (indigo drift, uniform radii, SaaS clichés, etc.).

- **Enable**: `enable_anti_slop_guard: true` in `.antigravity-local.md`
- **Triggers** on all `.tsx`, `.jsx`, `.css` files

---

## 📁 Project Structure

```bash
BASE/
├── .agents/                  # Core agent intelligence
│   ├── rules/                # Global + domain rules (including anti-slop-guard)
│   ├── skills/               # Expert skills (checkpoint-manager, taste-engine, etc.)
│   └── checkpoints/          # Trajectory backups
├── .gemini/antigravity/knowledge/
│   └── taste-profile.json    # Persistent user taste memory
├── AGENTS.md                 # Master routing + persona
├── .antigravity-local.md     # Local config (checkpoints + opt-ins)
└── README.md
```

---

## 🔥 Key Skills & Workflows

- **checkpoint-manager** → GStack-style trajectory persistence
- **taste-engine** → Personalized design intelligence
- **anti-slop-guard** → Aesthetic quality enforcement
- **db-migration, tdd-enforcer, security-audit, frontend-verify**, etc.

---

## 🛠️ How to Extend

1. Add new skills in `.agents/skills/`
2. Add new rules in `.agents/rules/`
3. Update routing in `AGENTS.md`
4. (Optional) Train your Taste Engine with `synchronize-taste`

All changes stay compliant with moderate modularity and non-negotiable safety guardrails.

---

## 📜 License
MIT © JackSmack1971

## 🤝 Contributing
Contributions that improve safety, add high-value skills, or tighten GStack integrations are welcome.

---
_Made for Antigravity • April 2026 Playbook with GStack Integration_
