# Workflow: pr-review
# Trigger: /workflow pr-review [pr-url]
# Architecture: L1 Orchestrator → diff + audit

## Phase 1 — Diff Analysis
Fetch PR diff and associated issue context.
Apply code-style and migration-guard Rules via glob matching.

## Phase 2 — Security Audit
Invoke security-audit Skill to screen for PII or secret leaks.
Identify sensitive API shifts.

## Phase 3 — Functional verification
Optionally trigger frontend-verify if UI components are touched.

## Phase 4 — Decision Artifact
Generate PR Review Artifact: [LGTM | Request Changes | Blocked]
Include inline code pointers and logic parity report.
