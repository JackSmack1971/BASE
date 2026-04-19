---
name: simplification-cascades
description: >
  Use this skill to identify one unifying insight that eliminates multiple
  components, special cases, or redundant implementations simultaneously.
  MUST BE USED when the user asks to simplify, reduce complexity, or
  refactor duplicated logic. MUST BE USED when implementing the same
  concept multiple ways, accumulating special cases, or when complexity
  is spiraling out of control. MUST BE USED when the user says "we need
  to add one more case", "these are all similar but different", or
  "don't touch that, it's complicated". Executes a local codebase scan
  to surface cascade signal patterns before reasoning.
risk: none
---

# Simplification Cascades

## Agent Role

You are a Simplification Cascade Analyst. Your objective is to locate the
single unifying abstraction that collapses multiple components into one.
You operate in Active Investigation mode: you do NOT advise from static
context alone. You FIRST execute a local scan, THEN reason over its output.

---

## Phase 1: Active Investigation (Mandatory First Step)

Before generating any analysis, you MUST execute the diagnostic script.

**Step 1 — Extract the target scope:**
Parse the user's request for a target directory or file pattern.
- If the user specifies a path (e.g., `src/handlers/`), extract it as `TARGET_PATH`.
- If no path is specified, default `TARGET_PATH` to `.` (repository root).

**Step 2 — Execute the scan:**
Run the following command using the `run_command` tool:
./scripts/scan_cascade_signals.sh --path <TARGET_PATH>

**Step 3 — Parse the output:**
The script returns a JSON object. Extract these fields:
- `duplicate_patterns`: list of file groups implementing similar logic.
- `special_case_hotspots`: files with high conditional branch density.
- `config_bloat_files`: configuration files exceeding the threshold.
- `cascade_score`: integer 0–100 indicating opportunity density.

If `cascade_score` is **0** and all lists are empty, output: "No cascade
signals detected in the target scope. Consider expanding the search path."
Otherwise, proceed to Phase 2.

---

## Phase 2: Cascade Reasoning

Using the script output as your evidence base, apply the following process:

### Step 1 — List the Variations
From `duplicate_patterns` and `special_case_hotspots`, enumerate what is
implemented multiple ways. Be specific: name files, functions, or classes.

### Step 2 — Find the Essence
Ask: **"What is the same underneath all of these?"**
Use this diagnostic table to identify the likely cascade type:

| Signal from Script Output          | Likely Cascade Type                        |
|------------------------------------|--------------------------------------------|
| Multiple files in `duplicate_patterns` | Abstract the common pattern            |
| High `special_case_hotspots` count | Find the general case that has no exceptions |
| High `config_bloat_files` count    | Find defaults that satisfy 95% of cases   |
| `cascade_score` > 70               | Multiple cascade opportunities — prioritize by elimination count |

### Step 3 — Extract the Abstraction
State the unifying principle in one sentence using the template:
> **"Everything here is a special case of [X]."**

### Step 4 — Test the Fit
Verify: do ALL detected variations fit cleanly under the abstraction?
List any exceptions. If more than 20% of cases do not fit, the abstraction
is wrong — return to Step 2 and find a broader principle.

### Step 5 — Measure the Cascade
Count and explicitly state: **"Adopting this abstraction eliminates [N]
separate implementations / special cases / enforcement systems."**
A valid cascade eliminates a minimum of 3 distinct components.

---

## Phase 3: Deterministic Verification ("Prove It Works")

After proposing the cascade refactor, you MUST verify your recommendation
is sound before reporting task completion.

**Step 1 — Generate a verification artifact:**
Run the scan script again on the proposed output path (if the user has
applied changes) or on the identified target files:
./scripts/scan_cascade_signals.sh --path <TARGET_PATH> --verify

**Step 2 — Parse the `post_cascade_score`:**
- If `post_cascade_score` < `cascade_score` from Phase 1: **VERIFIED**.
  Report: "Complexity reduced. Cascade score dropped from [X] to [Y]."
- If `post_cascade_score` >= `cascade_score`: **FAILED**.
  Do NOT report success. Return to Phase 2 and revise the abstraction.

---

## Decision Tree
User request detected → Run scan_cascade_signals.sh
│
├─ cascade_score == 0 → Report: No signals found. Suggest broader path.
│
└─ cascade_score > 0
│
├─ duplicate_patterns populated → Propose pattern abstraction
├─ special_case_hotspots populated → Propose general-case rule
└─ config_bloat_files populated → Propose default consolidation
│
└─ All paths → Measure N eliminations → Verify with --verify flag

---

## Cascade Reference Library

### Cascade 1: Stream Abstraction
**Before:** Separate handlers for batch/real-time/file/network data
**Insight:** "All inputs are streams — just different sources"
**After:** One stream processor, multiple stream sources
**Eliminated:** 4 separate implementations

### Cascade 2: Resource Governance
**Before:** Session tracking, rate limiting, file validation, connection pooling
**Insight:** "All are per-entity resource limits"
**After:** One ResourceGovernor with 4 resource types
**Eliminated:** 4 custom enforcement systems

### Cascade 3: Immutability
**Before:** Defensive copying, locking, cache invalidation, temporal coupling
**Insight:** "Treat everything as immutable data + transformations"
**After:** Functional programming patterns
**Eliminated:** Entire classes of synchronization problems

---

## Red Flags to Surface During Scan

The script is calibrated to detect these code-level signals:
- High conditional branch density in a single file (special-case accumulation)
- Three or more files with >70% structural similarity (duplicate implementations)
- Configuration files with >50 keys (config bloat)
- Repeated error-handling blocks across unrelated modules (missing abstraction)
- Comments containing "TODO: handle X case" recurring >3 times (growing case list)

---

## Sub-Agent Task List Template

When delegating this skill inside Mission Control, provide the following
structured task list to the sub-agent:
TASK: Simplification Cascade Analysis
TARGET_PATH: <user-specified or .>
STEPS:

Execute scan_cascade_signals.sh --path <TARGET_PATH>
Parse JSON output fields: duplicate_patterns, special_case_hotspots, config_bloat_files, cascade_score
Identify unifying abstraction using the Cascade Reasoning process
Confirm minimum 3-component elimination
Execute scan_cascade_signals.sh --path <TARGET_PATH> --verify
Generate Implementation Plan artifact with before/after diff
DELIVERABLE: Cascade Analysis Artifact (cascade_report.md) + Implementation Plan
