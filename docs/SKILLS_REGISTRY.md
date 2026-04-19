# Antigravity Skill Registry

This directory catalogs the expert capabilities available to Antigravity agents in the BASE workspace. Use these skills to enforce architectural integrity, automate complex workflows, and maintain production-grade quality.

---

## 🏗️ Architecture & Planning

| Skill | Optimal Use Case | Activation Trigger |
|---|---|---|
| **brainstorming** | Design-first exploration of new features or sub-projects. | "Design this", "Let's build X", "I want to add funcionality" |
| **planning** | Tracking progress on complex, multi-phase tasks. | "Create a plan", "Multi-step project", "Break this down" |
| **writing-plans** | Generating TDD-ready implementation plans from specs. | "Plan this feature", "Plan before coding", "Turn spec into tasks" |
| **context-engineering** | Auditing context layers and initializing sessions. | "Set up context", "Agent is hallucinating", "Audit context" |
| **context-compact** | Phase-based trajectory summarization & session-state preservation. | utilization_pct â‰¥ 70, HTTP 400 errors, "Compact context" |
| **design-review** | Senior designer audit and atomic UI fix loop using browser sub-agent. | "Audit design", "Visual QA", "Design polish", "UI review" |
| **agent-browser** | Professional browser automation, QA flows, and cloud browser environments. | "Open website", "Navigate to", "Scrape data", "Slack unread", "QA test" |

## 🗄️ Database & Infrastructure

| Skill | Optimal Use Case | Activation Trigger |
|---|---|---|
| **prisma-expert** | Complex schema modeling, migrations, and query optimization. | "Update Prisma", "Model this relation", "Optimize query" |
| **postgresql** | Advanced database design, indexing, and performance tuning. | "Design DB", "Tune SQL", "Explain plan" |
| **db-migration** | Running safe, production-grade schema migrations. | "Migration", "Change schema", "Update database" |
| **terraform-infrastructure** | Provisioning and managing cloud resources via IaC. | "Infrastructure", "Deploy AWS", "Create VPC" |

## 🎨 Frontend & UX

| Skill | Optimal Use Case | Activation Trigger |
|---|---|---|
| **taste-engine** | Applying user-specific aesthetic preferences to UI work. | "Apply taste", "Approve style", "Personalize design" |
| **anti-slop-guard** | Preventing generic AI design patterns in TSX/CSS. | [Automatic on UI files] |
| **tailwind-design-system** | Building token-based design systems with Tailwind v4. | "Tailwind tokens", "Setup theme", "Design system" |
| **radix-ui-design-system** | Creating accessible, headless UI components. | "Add Radix", "Headless component", "Accessible UI" |
| **shadcn** | Integrating and managing shadcn/ui components. | "Add shadcn", "Create component", "UI library" |

## 🛡️ Reliability & Security

| Skill | Optimal Use Case | Activation Trigger |
|---|---|---|
| **test-driven-development** | Strict Red-Green-Refactor development cycle. | "Implement feature", "Add function", "Write code" |
| **security-audit** | Threat modeling and OWASP-aligned code hardening. | "Audit security", "Secure this route", "OWASP check" |
| **wcag-audit-patterns** | Ensuring WCAG 2.2 accessibility compliance. | "Accessibility audit", "Check contrast", "Screen reader test" |
| **systematic-debugging** | Scientific diagnosis of bugs using root cause analysis. | "Debug this", "Fix bug", "Test failure" |
| **frontend-verify** | Browser-based QA and interaction verification. | "Browser test", "Verify UI", "QA loop" |

## ⚙️ Operations & Tooling

| Skill | Optimal Use Case | Activation Trigger |
|---|---|---|
| **changelog-generator** | Automating customer-facing release notes from git history. | "Create changelog", "Generate release notes" |
| **using-git-worktrees** | Clean branch isolation for parallel feature development. | "Create workspace", "Isolate branch", "Setup worktree" |
| **production-code-audit** | Transforming legacy code into professional codebases. | "Audit codebase", "Refactor for production", "Clean up" |
| **simplification-cascades** | Reducing complexity and redundant implementations. | "Simplify this", "Too complex", "Reduce duplication" |
| **semantic-versioning** | Automating project versioning and tag management. | "Bump version", "Release v1.2.0", "SemVer" |

---

## 📈 Integration Strategy

All skills in this registry should be registered in your **`GEMINI.md`** under the `## Skill Pointers` section to ensure 100% activation reliability during task intake.

_Last Updated: April 2026 • Part of the Antigravity Modernization Initiative_
