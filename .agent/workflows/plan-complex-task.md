# Workflow: plan-complex-task
# Trigger: /workflow plan-complex-task [description]
# Also auto-triggers when planning Skill activates on semantic match
# Architecture: L1 Orchestrator with optional Manager View parallelism

## Phase 0 — Bootstrap OR Resume Detection
CHECK: Does .gemini/antigravity/knowledge/session-state.md exist for this task?

IF NEW TASK (session-state.md absent):
  Invoke planning Skill Phase 1 bootstrap sequence.
  Instantiate session-state.md from references/session-state.tpl.md.
  Populate with: Task ID, Objective, Phases Declared (all status:pending),
    File Ownership declaration, empty Decisions/Blockers blocks.
  Generate Task List Artifact: phase map with owner assignments.
  STOP: Human reviews scope, phase structure, and file ownership before agents spawn.

IF RESUMING (session-state.md exists):
  Read session-state.md in full (re-read produces KV-cache-warm prefix).
  Generate Resume Brief Artifact:
    - Task ID and Objective (one line)
    - Phases: complete vs. remaining (table)
    - Last recorded Next Planned Action
    - Unresolved BLOCKERs (if any)
  STOP: Human confirms: "Resume TASK-{id} from [Next Planned Action]? Y/N"
  Proceed only after affirmative confirmation.

## Phase 1 — Track Isolation and Ownership Declaration
IF parallel tracks declared in Task List:
  Spawn L2 domain agents via Manager View.
  Each agent receives its own scoped state file: Agent-{X}-state.md
    Fields: Agent ID, owned files (explicit list), current sub-task,
            BLOCKER log, sub-phase status.
  Shared contracts (APIs, schemas, interfaces) are FROZEN before agents start.
  No agent modifies declared files of another agent. Violations halt execution.

IF single-track task:
  Proceed as single L2 agent with planning Skill active throughout.

## Phase 2 — Execution (per track / per phase)
All agents execute under active planning Skill constraints:
  Read-Before-Act: re-read session-state.md Current Objective before major decisions.
  2-Op Rule: write to domain-findings/ after every 2 research or browser ops.
  Error on Attempt 1: write BLOCKER to Agent-{X}-state.md on first failure.
  3-Strike: after 3 failures on same sub-task, flag ESCALATE.
  No verbatim retention: evict raw tool output after absorption.
  Pre-65% write: update session-state.md Next Planned Action before context
    utilization reaches 65% in any agent's context window.

STOP (after each phase or on ESCALATE): Human reviews consolidated progress.

PARALLEL MERGE PROTOCOL (executed by L1 Orchestrator at every STOP gate):
  Step 1: Read all Agent-{X}-state.md files from all active parallel tracks.
  Step 2: Merge into session-state.md using explicit precedence:
    Phases Declared: most advanced status wins (complete > in_progress > pending).
    Decisions Made: append all entries, deduplicate by timestamp.
    Unresolved Blockers: full union — no deduplication. All BLOCKERs preserved.
    Files Modified: full union of all agent file lists.
  Step 3: Discard Agent-{X}-state.md files after successful merge.
  Step 4: session-state.md is the single source of truth after every STOP gate.

## Phase 3 — Integration and Verification
Merge outputs from parallel tracks (if applicable).
Invoke frontend-verify Skill if any UI components were modified.
Invoke tdd-enforcer Skill if new logic was introduced.

## Phase 3b — Completion Verification and Continue-After-Completion Gate
Verify all phases in session-state.md show status:complete.
Generate Walkthrough Artifact:
  Contents: phase summary, files modified, errors encountered + resolutions,
            verification results, next recommended actions.

Present to human:
  "All phases complete. [Walkthrough Artifact attached]
   If additional work has emerged:
   → Confirm continuation to append new phases (session stays open)
   → Confirm closure to archive this task"

IF human signals continuation (Rule #7):
  Append new phases to session-state.md Phases Declared.
  Update Next Planned Action.
  Return to Phase 1 execution loop.
  DO NOT create a new session-state.md for follow-on work within the same task.

IF human confirms closure:
  Archive TASK-{id}-findings.md to knowledge/domain-findings/.
  Append novel error patterns to known-gotchas.md.
  Mark session-state.md status: CLOSED with timestamp.
  STOP: Human inspects final Walkthrough before task is formally closed.
