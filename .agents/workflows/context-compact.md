# Workflow: context-compact
# Trigger: /workflow context-compact
# Architecture: Single fast-inference agent, asynchronous

## Phase 1 — Trajectory Inventory
Agent reads full current session context.
Classifies each block: [retain-verbatim | summarize | evict].

## Phase 2 — State Synthesis
Agent writes session-state.md to .gemini/antigravity/knowledge/:
  - Current task objective
  - Decisions made and rationale
  - Files modified with change summaries
  - Unresolved blockers
  - Next planned action

## Phase 3 — Context Reinitialization
Active context reinitializes containing only:
  [1] AGENTS.md (universal rules, fresh load)
  [2] session-state.md (compressed trajectory)
  [3] Active L3 Skill fragment (current domain only)
Output Artifact: Compaction Summary.
STOP: Human inspects state snapshot before agent resumes.
