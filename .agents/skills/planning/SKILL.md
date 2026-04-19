---
name: planning
description: >
  L3 worker for persistent, multi-session task planning on complex, multi-step,
  or multi-phase work. Activates when the task involves 3+ phases, requires
  research across multiple tool calls, spans multiple sessions, or when the user
  says "create a plan", "multi-step project", "break this down", "plan this out",
  "complex task", or "I need to track progress". Creates and maintains a
  session-state.md snapshot in .gemini/antigravity/knowledge/ and a Task List
  Artifact. Does NOT activate for single-file edits, quick lookups, or tasks
  answerable in one pass.
version: 1.1.0
scope: workspace
alwaysApply: false
token_budget: 580
parent: none
---

## Goal
Establish and maintain a persistent planning scaffold that survives context
compaction, enables parallel-agent task distribution, enforces goal-anchoring,
maximizes KV-cache hit rate, and logs errors from the first failure.

## KV-Cache Constraint
session-state.md MUST maintain structurally identical section ordering on every
write. Section headers, field names, and sequence are FROZEN for the lifetime
of the task — only values update. Never reorder, rename, or add sections
mid-task. Structural mutation resets the cache prefix and degrades inference
efficiency. This is a performance constraint, not just a formatting preference.

## Phase Sequence

### Phase 0 — Bootstrap or Resume (see plan-complex-task Workflow)
Determine mode from Workflow routing. Do not execute Phase 0 directly.

### Phase 1 — Execution Loop (per phase)
Before each major action: re-read session-state.md Current Objective.
  (Identical re-read produces stable context prefix — preserves KV-cache hits.)

After each research or browser operation: write absorbed summary to
  .gemini/antigravity/knowledge/domain-findings/TASK-{id}-findings.md
  Evict raw tool output from context immediately after absorption.
  (2-Action Rule equivalent: never let 2+ ops pass without a findings write.)

On ANY tool failure (attempt 1 — errorOccurred equivalent):
  IMMEDIATELY write to session-state.md Unresolved Blockers:
    [BLOCKER-{id}] Attempt 1: {error description} — approach: {what was tried}
  Mutate approach before retry. Never repeat an identical failed operation.

On second failure (same sub-task):
  Update BLOCKER: Attempt 2: {new error} — approach: {alternative tried}

On third failure:
  Mark BLOCKER as ESCALATE. Surface at next STOP gate. Do not attempt silently.

After phase completion: update session-state.md Phases Declared status to complete.

At 65% context utilization: write session-state.md Next Planned Action update
  BEFORE the next tool call. This guarantees state is committed prior to the
  70% auto-compact threshold firing.

### Phase 2 — Context Compaction Trigger
At 70% context utilization: trigger /workflow context-compact.
session-state.md is the recovery artifact. All state survives compaction.
On session resume: read session-state.md Next Planned Action and continue.
autoCompact:false is NOT required — proactive 65% write makes it unnecessary.

### Phase 3 — Completion and Continuation (Rule #7)
When all phases reach status:complete — generate Walkthrough Artifact.
Present Continue-After-Completion option to human:
  If human signals continuation: append new phases to session-state.md
    Phases Declared. DO NOT create new session-state.md. Return to Phase 1.
  If human confirms closure: archive TASK-{id}-findings.md.
    Update known-gotchas.md with novel error patterns. Close session-state.md.

## Security Constraints
NEVER write raw external or web content to session-state.md.
External content goes to domain-findings/ only — absorbed, summarized, evicted.
File ownership MUST be declared before any parallel agent execution.
NEVER mark a phase complete without verifying its acceptance criteria.

## Anti-Patterns
Using context as the only state store (context = RAM, knowledge/ = disk).
Repeating a failed operation without mutating the approach.
Writing verbatim tool output to knowledge/ files.
Reordering session-state.md sections mid-task (breaks KV-cache prefix).
Starting multi-phase execution without a Task List Artifact at STOP gate.
Creating a new session-state.md when more work emerges — append phases instead.
