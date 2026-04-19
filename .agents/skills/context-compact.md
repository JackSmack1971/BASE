---
name: context-compact
description: >
  L3 worker for trajectory summarization, session-state synthesis, and context-window optimization.
  Triggered automatically at 70% context utilization to prevent "lost in the middle" degradation and HTTP 400 errors.
  Specializes in microcompaction (evicting raw tool outputs) and durable state archival.
  Does NOT activate for domain-specific coding, UI testing, or database schema modifications.
version: 1.1.0
scope: workspace
alwaysApply: false
token_budget: 550
parent: none
---

## Goal
Reduce current context footprint by minimum 70% while preserving mission-critical decisions, blockers, and trajectoral state for future turns.

## Phase Sequence
1. **Trajectory Assessment**: Read the full session history. Classify context blocks into: VERBATIM (active errors, user constraints), SUMMARIZE (resolved tool calls, reasoning traces), or EVICT (raw compiler dumps, directory listings).
2. **Durable State Synthesis**: Write a dense, structured `session-state.md` to the `.gemini/antigravity/knowledge/` directory. This document must capture the current objective, finalized decisions, modified files, and "Next Action" delta.
3. **Context Reinitialization**: Reinitialize the active context window. Retain ONLY `AGENTS.md` (universal foundation), `session-state.md` (the compressed mission trajectory), and the currently active L3 Skill fragment.
4. **Compaction Audit**: STOP. Generate a Compaction Summary Artifact showing tokens saved, blocks evicted, and a verification link to the new `session-state.md` for human inspection before resuming execution.

## Constraints
- NEVER omit unresolved stressors, active blockers, or explicit user-stated architectural constraints.
- NO verbatim shell or compiler outputs are permitted in the durable knowledge base.
- Does NOT activate for: Short sessions (under 10K tokens) or non-agentic read-only tasks.
- Trajectory summaries must be written in the 3rd-person executive director persona.

## Context This Worker Needs
- Current token utilization metrics (prefix total vs. window ceiling).
- Path to the project's durable memory directory (`.gemini/antigravity/knowledge/`).

## Output Artifact
- Type: Walkthrough | Compaction Summary
- Required fields: Tokens Evicted vs Retained, Metadata preserved, Link to session-state.md.

## MCP Tools Required
- write_to_file: used for updating the durable session-state.md record.
- view_file: used for analyzing context history and existing knowledge items.
- run_command: used for measuring token counts if external utilities are available.
