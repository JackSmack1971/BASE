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
- checkpoint-manager: Context persistence, mental model serialization (context-save/restore)
- db-migration       : PostgreSQL/ORM schema changes, Prisma migrations
- tdd-enforcer       : Test-first cycles, red-green-refactor enforcement
- security-audit     : Auth flows, JWT, crypto, penetration staging
- frontend-verify    : UI components, Browser Sub-Agent verification loops
- refactor-legacy    : Multi-file AST dependency tracing, entangled codebases
- context-compact    : Session compaction, trajectory summarization
- planning           : Persistent multi-session planning, KV-cache optimization

Available Workflows (trigger via /workflow):
- plan-complex-task  : Orchestrate multi-phase task bootstrapping and state merging
- plan-status        : Read-only dashboard for active planning session state
- full-stack-feature : Multi-agent orchestration for end-to-end feature delivery
- db-migration-safe  : Production-grade DB schema changes with mandatory backup checks
- context-compact    : Asynchronous session compaction and trajectory inventory
- monthly-maintenance: Automated workspace audit following the April 2026 stack
- pr-review          : Automated diff analysis and audit for pull requests

Available Rules (loaded via glob — never manually invoked):
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

## Context Budget Acknowledgment
# Positioned last to anchor attention on constraints before execution begins.
Doctrine: moderate modularity, no verbatim tool output retention,
phase-aware rule loading only. See .agents/skills/ for all domain logic.
