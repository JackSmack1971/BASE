# Changelog

All notable changes to the BASE project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2026-04-19

### ✨ New Features

- **Design Review Skill**: Deployed the critical-risk design-review skill to `.agents/skills/design-review/`.
  - Integrates Antigravity browser sub-agent for automated visual audits.
  - Implements a 10-category, 80+ item design checklist (hierarchy, typography, AI slop, etc.).
  - Orchestrates atomic design fix loops with before/after screenshot verification.
  - Adds 6 supporting workflow scripts for session setup, git safety, and telemetry.

### 🔧 Improvements

- **Skill Registry**: Added `design-review` to the official registry and global `GEMINI.md` activation hub.
- **BDD Testing**: Added `design_review_spec.sh` with passing status for session and git setup logic.

## [0.4.1] - 2026-04-19

### ✨ New Features

- **Context Engineering Skill**: Deployed the primary context optimization and hierarchy audit skill to `.agents/skills/context-engineering/`.
  - Added `audit_context.sh` for multi-layer hierarchy health checks.
  - Added `generate_brain_dump.sh` for automated session initialization.
  - Integrated `gemini_md_scaffold.md` for project-level architectural consistency.
  - Registered skill in `.gemini/GEMINI.md` under the global **Skill Pointers** hub.

### 🔧 Improvements

- **Skill Testing (BDD)**: Authored `context_engineering_spec.sh` validating auditing logic and stack detection with a 100% pass rate.
- **Global Strategy**: Established the **Skill Pointers** pattern in `GEMINI.md` to ensure reliable tool activation across all sessions.

## [0.4.0] - 2026-04-19

### ✨ New Features

- **Automated Skill Testing**: Implemented a comprehensive ShellSpec (Bash BDD) testing framework for all project agent skills.
  - Added test suites for `brainstorming`, `changelog-generator`, `simplification-cascades`, `test-driven-development`, `using-git-worktrees`, and `writing-plans`.
  - Created a native PowerShell 5.1 wrapper (`tests/test-skills.ps1`) for seamless integration in Windows environments.
  - **Requirement**: All new or modified skill scripts must now include a corresponding ShellSpec test suite in the `spec/` directory to ensure architectural integrity and reliability.

### 🔧 Improvements

- **Skill Stability**: Hardened all core skill scripts with Python 3 support, POSIX path resolution, and carriage return sanitization for cross-environment reliability.
- **Simplification Cascades**: Fixed mathematical syntax errors in signal detection logic.
- **Writing Plans**: Eliminated duplicate placeholder patterns in the validation engine.

## [0.3.0] - 2026-04-19

### ✨ New Features

- **Changelog Generator**: Added the core skill definition and implementation plan for automated release note generation.
- **Skill Documentation**: Added examples and updated global documentation for the changelog-generator skill.
- **Skills Modernization**: Completed the transition to modern, script-backed skills (Brainstorming, Writing Plans, Worktrees, TDD) and GStack integration.
- **GStack Phase 2**: Integrated the Taste Engine and Anti-Slop Guard for personalized aesthetics and automated QA.
- **GStack Phase 1**: Integrated Continuous Checkpoints for durable session state and mental model persistence.
- **Modern Standards**: Migrated the core configuration directory to the `.agents/` plural standard for multi-agent support.
- **Persistent Planning**: Established the complete v1.1 persistent planning architecture with L3 optimization and safety guards.

### 🔧 Improvements

- **Cleanup**: Systematically removed temporary integration artifacts (analysis, plan, walkthrough).
- **Changelog**: Finalized GStack Phase 2 completion entries in the master changelog.
- **README**: Finalized GStack integration documentation and project structure.
- **Changelog Setup**: Established the comprehensive `CHANGELOG.md` following the Keep a Changelog v1.0.0 standard.
- **Routing Index**: Updated the routing index with a full library of workflows and safety rules.
- **README Links**: Added official Antigravity and DeepMind technology links for improved branding.
- **README Fix**: Corrected code block formatting within the primary documentation.
- **README Style**: Improved the formatting of the BASE description for better scannability.
- **Quick Start**: Enhanced the README with a detailed BASE description and comprehensive quick-start guide.
- **Onboarding**: Updated the README with supplementary information regarding the Antigravity starter template.
- **Branding**: Revised the README for improved clarity, professional branding, and structural transparency.
- **Media Assets**: Uploaded supporting files and images for the project documentation.
- **Media Assets**: Provided additional visual context through uploaded files.
- **Media Assets**: Integrated core assets for the Antigravity ecosystem.
- **Media Assets**: Finalized the initial asset upload for the project skeleton.
- **Bootstrap**: Initial establishment of the Master Antigravity Integration Playbook (April 2026 Edition).
- **Core Repository**: Initialized the project with the foundational repository structure.

## [0.2.0] - 2026-04-19

### Added
- **Full Workflow Registry**: Registered all remaining L1 Orchestrators in `AGENTS.md` (including `full-stack-feature`, `db-migration-safe`, `context-compact`, `monthly-maintenance`, and `pr-review`).
- **Safety Rule Registration**: Formally added the `_master` universal persona and guardrail rule to the `AGENTS.md` routing index.

### Changed
- **Architectural Modernization**: Migrated the core configuration directory from legacy `.agent/` to the modern `.agents/` (plural) standard to support multi-agent orchestration.
- **Global Path Update**: Updated all internal path references and external documentation (README, AGENTS.md, workflows) to reflect the new `.agents/` convention.
- **GStack Integration Phase 2**: Deployed the **Taste Engine** (personalization) and **Anti-Slop Guard** (aesthetic QA) as opt-in advanced intelligence layers.
- **Final Documentation**: Refreshed the root `README.md` to reflect the complete GStack-powered BASE stack.

## [0.1.1] - 2026-04-19

### Added
- **Persistent Planning Stack (v1.1)**: Integrated the April 2026 Bridge Builder planning methodology.
- **L3 Planning Engine**: Established `.agents/skills/planning/SKILL.md` for KV-cache optimized state persistence and attempt-1 error logging.
- **L1 Orchestration**: Created `plan-complex-task` and `plan-status` workflows for persistent multi-session task management.
- **Security Protocols**: Implemented `planning-guard.md` to prevent non-deterministic execution of multi-phase tasks.
- **Session Templates**: Created a schema-frozen `session-state.tpl.md` reference for durable memory.

### Fixed
- **Documentation Overhaul**: Comprehensive refresh of the `README.md` with official Antigravity and DeepMind technology links, badge integration, and project structure documentation.

## [0.1.0] - 2026-04-18

### Added
- **Initial Bootstrap**: Primary establishment of the Master Antigravity Integration Playbook.
- **Core Skills Library**: Initial rollout of expert skills including `db-migration`, `tdd-enforcer`, `security-audit`, `frontend-verify`, `refactor-legacy`, and `context-compact`.
- **Baseline Guardrails**: Rollout of the 5-layer safety stack and initial routing index.
- **Project Skeleton**: Created the recommended foundational folder structure for the Antigravity ecosystem.

---
_Generated for the April 2026 Playbook • Modernization Phase Complete_
