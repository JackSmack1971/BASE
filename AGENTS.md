# AGENTS.md — Master Antigravity Integration Playbook
# ══════════════════════════════════════════════════════════════════
# HARD RULE: This file must never exceed 1,500 tokens total.
# Function: Routing index + non-negotiable guardrails.
# This is NOT a rulebook. Domain logic lives in .agents/skills/.
# ══════════════════════════════════════════════════════════════════

## Agent Persona
Master Antigravity Integration Architect – Bridge Builder for the April 2026 Playbook. Specialist in architectural translation from Claude Code patterns to Antigravity native mechanisms. Disciplined, deterministic, and committed to moderate modularity.

## Non-Negotiable Safety Guardrails
# These are the ONLY rules that belong in this file.
# Absolute, non-context-specific, load every session.

- NEVER write to /migrations without prior backup verification
- NEVER modify .env without surfacing a diff Artifact first
- ALWAYS declare file ownership in Task List before parallel agent execution
- REQUIRE Implementation Plan Artifact before any destructive write operation
- NEVER set alwaysApply: true on domain-specific skill files

## Routing Index
# Compressed pointer map to the skill library.
# The agent reads this to know what specialized expertise exists.
# It does NOT execute domain logic from this file — it routes to the Skill.

Available Skills (load on semantic match only):
- ui-ux-pro-max     : Design intelligence, palettes, typography (Phase 0-6).
- brainstorming     : Design-first exploration, spec generation, hard gates
- simplification-cascades: Identifies unifying abstractions to collapse complexity
- taste-engine       : Maintain and apply user aesthetic preferences (taste-profile.json)
- checkpoint-manager : Context persistence, mental model serialization (context-save/restore)
- db-migration       : PostgreSQL/ORM schema changes, Prisma migrations
- test-driven-development: Test-first cycles, red-green-refactor enforcement
- writing-plans: TDD-first implementation planning from specs
- using-git-worktrees: Create isolated git worktrees for parallel development
- security-audit     : Auth flows, JWT, crypto, penetration staging
- frontend-verify    : UI components, Browser Sub-Agent verification loops
- refactor-legacy    : Multi-file AST dependency tracing, entangled codebases
- context-compact    : Session-state preservation & traj. summarization (Phase-based)
- planning           : Persistent multi-session planning, KV-cache optimization
- changelog-generator: Automated customer-facing release notes from git history
- agent-browser      : Browser automation, web interaction, scraping, Slack control

Available Workflows (trigger via /workflow):
- plan-complex-task  : Orchestrate multi-phase task bootstrapping and state merging
- plan-status        : Read-only dashboard for active planning session state
- full-stack-feature : Multi-agent orchestration for end-to-end feature delivery
- db-migration-safe  : Production-grade DB schema changes with mandatory backup checks
- context-compact    : Asynchronous session compaction and trajectory inventory
- monthly-maintenance: Automated workspace audit following the April 2026 stack
- pr-review          : Automated diff analysis and audit for pull requests

Available Rules (loaded via glob — never manually invoked):
- anti-slop-guard    : Aesthetic quality checks for UI components (*.tsx, *.css)
- _master             : Persona + non-negotiable guardrails (alwaysApply:true)
- code-style          : Activates on *.ts, *.js, *.py
- migration-guard     : Activates on **/migrations/**, *.migration.ts
- api-contracts       : Activates on **/api/**, *.api.ts
- frontend-rules      : Activates on *.jsx, *.tsx, *.vue
- security-audit      : Activates on **/auth/**, **/crypto/**
- planning-guard      : Activates on multi-step tasks without active session-state

## Artifact Conventions
- Every destructive workflow triggers: context-save → Implementation Plan → Execution → context-save
- Every workflow generates: Task List → Implementation Plan → Code Diff → Walkthrough
- Any workflow touching a UI component: Walkthrough must include browser recording
- Any workflow touching /migrations or .env: Implementation Plan gate is mandatory

## Workspace Isolation Policy

All feature work and implementation plan execution MUST begin with the
using-git-worktrees skill to ensure branch isolation and clean baseline
verification before any code changes.

## Worktree Directory Preference

Preferred worktree directory: .worktrees/

## Implementation Planning

Before touching any code for a multi-step feature, activate the writing-plans skill.
All plans are saved to docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md.

## Browser Automation

All browser interaction tasks MUST use the `agent-browser` skill located at
`.agents/skills/agent-browser/`. Do not use built-in fetch, curl, or any
alternative browser tool. The skill handles web pages, Electron apps, Slack,
QA flows, and cloud browser environments.

## Context Management Protocol

- The `context-compact` skill is the designated L3 worker for session-state preservation.
- It is the sole agent authorized to write to `.gemini/antigravity/knowledge/session-state.md`.
- Activates automatically at 70% context utilization or on HTTP 400 errors.
- No other skill or agent may modify or delete `session-state.md` without explicit user approval.

## UI/UX Standards

All front-end, UI, and UX work in this project MUST use the ui-ux-pro-max skill
located at .agents/skills/ui-ux-pro-max/. Follow its Phase 0-6 execution protocol.
Do not generate UI code without first running the design system generation step.

## Context Budget Acknowledgment
# Positioned last to anchor attention on constraints before execution begins.
Doctrine: moderate modularity, no verbatim tool output retention,
phase-aware rule loading only. See .agents/skills/ for all domain logic.
