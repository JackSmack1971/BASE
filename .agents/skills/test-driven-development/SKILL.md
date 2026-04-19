---
name: test-driven-development
description: >
  MUST BE USED when the user asks to implement any new feature, fix any bug,
  perform any refactor, or make any behavior change. MUST BE USED when the user
  says "write code", "add a function", "fix this bug", "refactor", or "implement".
  MUST BE USED before any production code is written. Enforces the Red-Green-Refactor
  TDD cycle using local test execution via run_command. MUST BE USED when the user
  asks "how do I test this", "write a test for", or "TDD this". MUST BE USED when
  a failing test needs to be authored, verified, and then driven to green with
  minimal implementation code. Executes the strict Iron Law: NO PRODUCTION CODE
  WITHOUT A FAILING TEST FIRST.
risk: safe
---

# Test-Driven Development (TDD) — Antigravity Runtime Skill

## Core Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Wrote code before the test? Delete it. Start over. No exceptions.

---

## Agent Execution Protocol

You are a deterministic TDD enforcer. You do not advise — you execute. Follow the
Decision Tree below in strict sequence. Never proceed to the next stage without
running the verification script and receiving a valid JSON signal.

### Stage Identification and Argument Extraction

Before executing any stage:

1. Extract the **test file path** from the user's request (e.g., `src/utils/retry.test.ts`).
   If no path is specified, ask: "What is the path to the test file for this feature?"
2. Extract the **current TDD stage** from context: `red`, `green`, or `refactor`.
   If ambiguous, default to `red`.
3. Pass both values to `./scripts/run_tdd_cycle.sh` using flags:
   - `--test-path <relative-path-to-test-file>`
   - `--stage <red|green|refactor>`

---

## Decision Tree: Red-Green-Refactor

### STAGE 1 — RED: Write the Failing Test

**Action:**
1. Author one minimal test that defines the desired behavior. Requirements:
   - One behavior per test.
   - Descriptive name (describes behavior, not implementation).
   - Uses real code — no mocks unless the dependency is external and unavoidable.
2. Save the test file.
3. Execute verification:

```
Run ./scripts/run_tdd_cycle.sh --test-path <path> --stage red via run_command.
```

**Parse JSON output:**
- `"stage_result": "FAIL_CORRECT"` → Proceed to STAGE 2.
- `"stage_result": "PASS_UNEXPECTED"` → STOP. The test is testing existing behavior. Revise the test and re-run.
- `"stage_result": "ERROR"` → Fix the syntax/compile error, re-run. Do not proceed until `FAIL_CORRECT`.

**Red flags that require a full stop and restart:**
- Test passes immediately.
- You cannot explain the expected failure message.
- Failure is caused by a typo or missing import, not a missing feature.

---

### STAGE 2 — GREEN: Write Minimal Implementation

**Action:**
1. Write the simplest code that makes the test pass. No extra features. No YAGNI violations.
2. Do not refactor other code. Do not improve unrelated functions.
3. Execute verification:

```
Run ./scripts/run_tdd_cycle.sh --test-path <path> --stage green via run_command.
```

**Parse JSON output:**
- `"stage_result": "ALL_PASS"` → Proceed to STAGE 3.
- `"stage_result": "TARGET_FAIL"` → Fix implementation only. Re-run.
- `"stage_result": "REGRESSION"` → A previously passing test is now broken. Fix regression before proceeding.
- `"stage_result": "ERROR"` → Fix compile/runtime error. Re-run.

---

### STAGE 3 — REFACTOR: Clean Up Under Green

**Action:**
1. Improve code quality only: remove duplication, improve names, extract helpers.
2. Add zero new behavior.
3. Execute verification:

```
Run ./scripts/run_tdd_cycle.sh --test-path <path> --stage refactor via run_command.
```

**Parse JSON output:**
- `"stage_result": "ALL_PASS"` → Cycle complete. Generate a Completion Artifact (see below).
- `"stage_result": "REGRESSION"` → Refactor broke a test. Revert last change. Re-run.

---

## Completion Artifact

After a successful REFACTOR verification, generate the following artifact and save it:

```json
{
  "artifact_type": "TDD_CYCLE_COMPLETE",
  "test_file": "<path>",
  "behavior_tested": "<one-sentence description>",
  "stages_verified": ["red", "green", "refactor"],
  "all_tests_passing": true,
  "notes": "<any relevant observations>"
}
```

---

## Sub-Agent Task List (Mission Control)

For complex features requiring parallel execution:

- **Agent 1 (TDD-RED):** Author and verify the failing test. Output: confirmed `FAIL_CORRECT` signal.
- **Agent 2 (TDD-GREEN):** Receive test file path from Agent 1. Implement minimal code. Output: `ALL_PASS` signal.
- **Agent 3 (TDD-REFACTOR):** Receive codebase state from Agent 2. Execute refactor under green. Output: Completion Artifact.

Agents must not start their stage until the preceding agent's JSON signal is confirmed.

---

## Anti-Pattern Reference

For guidance on mocking, test utilities, and coupling issues, execute:

```
Read ./resources/testing-anti-patterns.md via run_command before authoring tests
that require mocks or shared test utilities.
```

---

## Rationalization Interception

If the user or context suggests any of the following, STOP and enforce restart:

| Signal | Required Action |
|--------|-----------------|
| "write tests after" | Halt. Remind: tests-after answer "what does this do?" — not "what should this do?" |
| "already manually tested" | Halt. Manual = ad-hoc. No record. Can't re-run. |
| "keep as reference" | Halt. Delete means delete. Looking at existing code biases tests. |
| "just this once" | Halt. That is the rationalization. |
| "TDD is dogmatic" | Halt. TDD is faster than debugging production. |
| "deleting X hours is wasteful" | Halt. Sunk cost. Unverified code is technical debt. |

---

## Verification Checklist (Emit Before Marking Complete)

- [ ] Test authored before any production code
- [ ] `FAIL_CORRECT` signal received and parsed at RED stage
- [ ] `ALL_PASS` signal received at GREEN stage
- [ ] `ALL_PASS` signal received at REFACTOR stage
- [ ] Completion Artifact generated
- [ ] No mocks used unless external dependency unavoidable
- [ ] Edge cases and error paths covered by tests

Cannot check all boxes? TDD was not followed. Restart.
