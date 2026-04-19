# Workflow: monthly-maintenance
# Trigger: /workflow monthly-maintenance
# Architecture: L1 Orchestrator implementing the Section 6.1 Audit Stack

## Phase 1 — Knowledge Audit
- **Goal**: Detect divergence between durable state and active codebase.
- **Action**: Diff all files in `.gemini/antigravity/knowledge/` against the current source code state.
- **Output**: `knowledge-audit-report.md` artifact.
- STOP: Human review required before proceeding to granularity sweep.

## Phase 2 — Granularity & Token Budget Sweep
- **Goal**: Enforce Moderate Modularity (300-800 tokens) and L0 caps (1,500 tokens).
- **Action**: Scan all files in `.agent/rules/`, `.agent/skills/`, and root `AGENTS.md`.
- **Output**: `granularity-audit.md` artifact with pass/fail status per file.
- STOP: Human review required before proceeding to risk validation.

## Phase 3 — Risk Matrix + Guardrail Validation
- **Goal**: Verify health of the 5-layer guardrail stack.
- **Action**: Run self-audit against Playbook Section 6.1 Risk Matrix. Verify structural integrity of the guardrail stack.
- **Output**: `risk-matrix-status.md` artifact.

## Phase 4 — Compaction & Evolution
- **Goal**: Optimize context and plan for future capability growth.
- **Action**: Trigger `/workflow context-compact`. Generate evolution recommendations for new skills or rules based on recent session history.
- **Output**: `monthly-evolution-plan.md` artifact.
- STOP: Human review of the evolution plan before final walkthrough.

## Phase 5 — Final Walkthrough
- **Goal**: Certify workspace health for the current month.
- **Output**: Walkthrough Artifact titled "Monthly Maintenance — April 2026 Master Workspace (YYYY-MM)" including token savings and green-check certification.
