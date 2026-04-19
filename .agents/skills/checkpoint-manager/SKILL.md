---
name: checkpoint-manager
description: >
  L3 worker for trajectory persistence and mental model safety. 
  Implements GStack-compatible context-save and context-restore protocols using structured Git WIP commits and local JSON backups. 
  Prevents hours of work loss during context compaction or multi-agent handoffs.
version: 1.0.0
scope: workspace
alwaysApply: false
token_budget: 650
parent: none
---

## Goal
Establish a 100% resilient development trajectory by serializing the agent's mental state and file system delta at every high-impact milestone.

## Commands (Action Set)
1. **`context-save [message]`**:
   - Capture: `Decisions Made`, `Tried/Failed Approaches`, and `Remaining Logical Steps`.
   - Persistence: Save a timestamped snapshot to `.agents/checkpoints/` and create a structured Git WIP commit (using `[base-context]` nomenclature) on a hidden `checkpoint/*` branch.
2. **`context-restore [id|latest]`**:
   - Retrieval: Load the specified mental model and apply the Git patch/WIP commit to the active working tree.
3. **`checkpoint-status`**:
   - Summary: Display the health of the checkpoint system, current `checkpoint_mode`, and the last 5 milestones in the history.

## Constraints
- **Main Branch Integrity**: NEVER commit checkpoints directly to `main` or permanent history without explicit user approval.
- **Git Protocol**: Use `git commit --no-verify` for WIP commits to ensure zero latency.
- **Data Boundary**: External research (web/MCP) remains in `domain-findings/`; only summarized "absorbed" insights enter the checkpoint mental model.
- **Naming Parity**: Use GStack-compatible naming conventions for commands to ensure cross-platform muscle memory for integration architects.

## Context This Worker Needs
- Active Git branch state.
- `.antigravity-local.md` configuration for `checkpoint_mode`.
- Status of the `checkpoint/*` branch for diff tracking.

## Output Artifact
- Type: Implementation Plan | Walkthrough
- Required fields: Checkpoint ID, Git WIP Hash, Mental Model (Decisions/Remaining).

## MCP Tools Required
- run_command: for git branch management and patch application.
- write_to_file: for JSON state serialization in `.agents/checkpoints/`.
- list_dir: for checkpoint history scanning.
