# Workflow: plan-status
# Trigger: /workflow plan-status
# Architecture: Single read-only agent — no writes, no STOP gates, no side effects

## Phase 1 — State Read
Read .gemini/antigravity/knowledge/session-state.md (READ ONLY — no modifications).

IF session-state.md not found:
  Respond: "No active planning session found. Run /workflow plan-complex-task
  to initialize. Or specify a TASK-ID if working in a multi-task environment."
  STOP. No further action.

## Phase 2 — Status Surface
Generate Status Artifact with the following fields (no prose, structured only):
  - Task ID + Objective (one line)
  - Phase completion table:
      | Phase | Status | Owner |
      |-------|--------|-------|
  - Unresolved BLOCKERs: count + list of ESCALATE-flagged items
  - Next Planned Action (verbatim from session-state.md)
  - Last Updated timestamp (from session-state.md header)
  - Context utilization at last write (if recorded)

NO writes to any file.
NO modifications to session-state.md.
NO STOP gates.
This Workflow has zero side effects. It is a pure read.
