---
name: context-compact
description: >
  Use this skill to compact, compress, and optimize the active context window when it is nearing
  its capacity limit. MUST BE USED when the user reports HTTP 400 errors caused by context overflow.
  MUST BE USED when context utilization reaches or exceeds 70% of the window ceiling.
  MUST BE USED when the agent begins losing coherence, repeating prior reasoning, or failing to
  recall earlier architectural decisions. Executes a 4-phase trajectory summarization pipeline:
  Trajectory Assessment, Durable State Synthesis, Context Reinitialization, and Compaction Audit.
  Writes a persistent session-state.md to the .gemini/antigravity/knowledge/ directory.
  Does NOT activate for sessions under 10K tokens, read-only tasks, domain-specific coding,
  UI testing, or database schema modifications.
risk: safe
version: 1.1.0
scope: workspace
---

## Purpose

This skill is the session-state preservation and context-window optimization worker for Antigravity
Mission Control. It prevents "lost in the middle" attention degradation by evicting irrelevant
context blocks and synthesizing a durable, machine-parseable mission trajectory into the project
knowledge base. It does NOT modify application code or schema.

---

## Activation Conditions

Before beginning, verify ALL of the following using `run_command`:

1. Execute `./scripts/measure_tokens.sh` and parse the returned JSON.
2. Confirm `utilization_pct` ≥ 70 OR `trigger_reason` is "http_400_overflow".
3. Confirm `session_tokens` > 10000.
4. Confirm the current task is NOT: domain-specific coding, UI testing, or database schema modification.

If any condition is unmet, output: `CONTEXT-COMPACT: Activation conditions not satisfied. Reason: [reason]. Skill halted.` and stop.

---

## Argument Extraction

Extract the following from the user's prompt or current session state before executing any phase:

- `PROJECT_ROOT`: The root directory of the current workspace (default: current working directory).
- `KNOWLEDGE_DIR`: Path to the durable memory store. Default: `$PROJECT_ROOT/.gemini/antigravity/knowledge/`.
- `TRIGGER_REASON`: One of `auto_70pct`, `http_400_overflow`, `manual`. Extract from context or prompt.
- `SESSION_ID`: If available, extract from context metadata; otherwise generate as `compact_$(date +%s)`.

Pass these as environment variables or `--flag` arguments to all scripts below.

---

## Phase Sequence

### Phase 1 — Trajectory Assessment

1. Execute `./scripts/assess_trajectory.sh --project-root "$PROJECT_ROOT"` via `run_command`.
2. The script reads active session blocks and returns a JSON classification manifest:
```json
   {
     "verbatim_blocks": [...],
     "summarize_blocks": [...],
     "evict_blocks": [...],
     "token_counts": { "verbatim": N, "summarize": N, "evict": N }
   }
```
3. Verify the JSON is valid and `evict_blocks` is non-empty before proceeding.
4. **NEVER evict:** unresolved blockers, active errors, explicit user architectural constraints, or the current `AGENTS.md` content.
5. **ALWAYS evict:** raw shell/compiler stdout dumps, directory listings, resolved tool call traces, intermediate reasoning scratchpads.

### Phase 2 — Durable State Synthesis

1. Execute `./scripts/synthesize_state.sh --knowledge-dir "$KNOWLEDGE_DIR" --session-id "$SESSION_ID"` via `run_command`, passing the Phase 1 JSON manifest via stdin or a temp file at `/tmp/trajectory_manifest.json`.
2. The script writes `session-state.md` to `$KNOWLEDGE_DIR/session-state.md`.
3. `session-state.md` MUST contain the following sections (written in 3rd-person executive director persona):
   - `## Current Objective` — active mission goal
   - `## Finalized Decisions` — architectural choices locked in this session
   - `## Modified Files` — list of all files written or changed
   - `## Active Blockers` — unresolved errors or constraints (VERBATIM, never evicted)
   - `## Next Action Delta` — exact next step for the agent upon context reinitialization
4. Verify `session-state.md` exists and is non-empty using `run_command`: `./scripts/verify_artifact.sh --path "$KNOWLEDGE_DIR/session-state.md"`. Expect `{"status": "OK", "size_bytes": N}`. If status is not OK, halt and report error.

### Phase 3 — Context Reinitialization

1. Instruct the agent: retain ONLY the following three context elements going forward:
   - `AGENTS.md` (universal project foundation — always-active)
   - `$KNOWLEDGE_DIR/session-state.md` (the compressed mission trajectory written in Phase 2)
   - The currently active L3 Skill fragment (this file, context-compact SKILL.md)
2. All other context blocks classified as EVICT in Phase 1 are dropped from the active window.
3. Do NOT reinitialize until Phase 2 verification passes.

### Phase 4 — Compaction Audit (MANDATORY STOP)

1. Execute `./scripts/compaction_audit.sh --session-id "$SESSION_ID" --knowledge-dir "$KNOWLEDGE_DIR"` via `run_command`.
2. The script returns and writes a `compaction_summary.json` artifact to `$KNOWLEDGE_DIR/compaction_summary_$SESSION_ID.json`:
```json
   {
     "session_id": "...",
     "tokens_before": N,
     "tokens_evicted": N,
     "tokens_retained": N,
     "reduction_pct": N,
     "blocks_evicted": [...],
     "metadata_preserved": ["AGENTS.md", "session-state.md"],
     "session_state_path": "...",
     "status": "COMPACTION_COMPLETE"
   }
```
3. **HARD STOP:** Present the Compaction Summary Artifact to the human operator for inspection. Do NOT resume task execution until explicit human approval is received.
4. Verify `reduction_pct` ≥ 70. If not, re-run Phase 1 with broader EVICT classification and repeat.

---

## Constraints (Non-Negotiable)

- NEVER omit unresolved stressors, active blockers, or user-stated architectural constraints from `session-state.md`.
- NO verbatim shell or compiler output is permitted in any durable knowledge base artifact.
- This skill does NOT modify application source code, database schemas, or UI components.
- All script outputs must be JSON-formatted for deterministic parsing. Plain text output is a failure condition.

---

## Sub-Agent Compatibility

If delegated by Mission Control as a sub-agent task:

**Task List:**
1. [ ] Measure token utilization → `measure_tokens.sh`
2. [ ] Classify trajectory blocks → `assess_trajectory.sh`
3. [ ] Write `session-state.md` → `synthesize_state.sh`
4. [ ] Verify artifact integrity → `verify_artifact.sh`
5. [ ] Generate Compaction Summary → `compaction_audit.sh`
6. [ ] STOP and surface artifact to orchestrating agent for human review gate

**Implementation Plan:** Execute phases sequentially. Each phase must receive a JSON-OK signal from the preceding phase's verification step before proceeding. On any non-OK status, generate an error artifact and halt — do not attempt recovery autonomously.
