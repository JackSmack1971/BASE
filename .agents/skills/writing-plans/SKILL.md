---
name: writing-plans
description: >
  Use this skill to generate a comprehensive, TDD-first implementation plan from
  a spec, requirements document, or feature description before any code is written.
  MUST BE USED when the user says "write a plan", "create an implementation plan",
  "plan this feature", "plan before coding", "turn this spec into tasks", or
  "generate a task list from requirements". Activate when the user provides a spec
  and asks how to implement it. Executes a self-review and saves the plan as a
  dated Markdown artifact. REQUIRED before any multi-step implementation begins.
risk: safe
---

# Writing Plans

## Activation Announcement

At the very start of execution, output exactly:
> "I'm using the writing-plans skill to create the implementation plan."

---

## Phase 0: Argument Extraction (Run First — Before Any Output)

Before generating any content, extract the following from the user's prompt or attached spec:

1. **`feature-name`**: A short, lowercase, hyphenated identifier (e.g., `user-auth-refactor`). Infer from the spec title or primary objective.
2. **`plan-date`**: Today's date in `YYYY-MM-DD` format. Use `run_command` to execute `date +%Y-%m-%d` and capture the output.
3. **`plan-location`**: Default is `docs/superpowers/plans/`. If the user specifies an override path, use that instead.
4. **`output-filename`**: Assemble as `{plan-date}-{feature-name}.md`.
5. **`output-path`**: Full path = `{plan-location}{output-filename}`.

Execute via `run_command`:
```bash
./scripts/get_date.sh
```
Parse the output for the `DATE` value before proceeding.

---

## Phase 1: Scope Check

Before writing any tasks, evaluate the spec:

- Does the spec cover **multiple independent subsystems** (e.g., authentication AND data layer AND UI)?
- If yes: HALT plan generation. Output a recommendation to break the spec into sub-project specs — one per subsystem — each producing independently testable, working software. Ask the user which subsystem to plan first.
- If no: Proceed to Phase 2.

---

## Phase 2: File Structure Mapping

Map all files that will be created or modified. Lock in decomposition decisions here:

- Each file has **one clear responsibility** — no files that do too much.
- Files that change together live together — split by responsibility, not technical layer.
- In existing codebases: follow established patterns. If a file you're modifying has grown unwieldy, include a split in the plan.
- Define interfaces and boundaries explicitly in this section.

This structure drives task decomposition. Each task must produce self-contained changes.

---

## Phase 3: Plan Document Generation

### Mandatory Plan Header

Every plan MUST begin with this exact header (populate all fields — no placeholders):

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about the implementation approach]

**Tech Stack:** [Key technologies and libraries used]

---
```

### Task Structure (Repeat for Every Task)

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
```

### Bite-Sized Task Granularity Rules

Each step is **one discrete action (2–5 minutes)**. Do not combine steps. TDD sequence is mandatory:
1. Write the failing test
2. Run it — confirm it fails
3. Write minimal implementation
4. Run the test — confirm it passes
5. Commit

### Hard Rules — No Placeholders

These patterns are **plan failures**. Never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (always repeat full code — engineer may read out of order)
- Steps describing *what* to do without showing *how* (code blocks required for all code steps)
- References to types, functions, or methods not yet defined in any task

### Guiding Principles

- **DRY**: Do not repeat logic across modules.
- **YAGNI**: Do not plan features not in the spec.
- **TDD**: Tests before implementation in every task.
- **Frequent commits**: Every task ends with a commit step.
- Assume a skilled developer who knows almost nothing about this toolset or problem domain and who may have weak test design instincts. Be explicit.

---

## Phase 4: Self-Review (Run After Draft Is Complete)

After the full plan draft is written, run the validation script:

```bash
./scripts/validate_plan.sh --plan-path "{output-path}"
```

Parse the JSON output:
- **`spec_gaps`**: List of spec requirements not covered by any task. If non-empty, add missing tasks inline.
- **`placeholder_hits`**: List of lines matching forbidden placeholder patterns. Fix every hit.
- **`type_inconsistencies`**: Flag if method names used in later tasks differ from definitions in earlier tasks.

Fix all issues before proceeding. No re-review needed — fix inline and move on.

---

## Phase 5: Save and Verify ("Prove It Works" Protocol)

After self-review is clean, save the plan:

```bash
./scripts/save_plan.sh --path "{output-path}" --content "{escaped-plan-content}"
```

Parse the script output:
- **`STATUS: SAVED`** → File confirmed on disk. Proceed to Phase 6.
- **`ERROR: ...`** → Do NOT report completion. Surface the error to the user and retry or request manual save.

Do not announce plan completion until `STATUS: SAVED` is confirmed.

---

## Phase 6: Execution Handoff

After confirming save, output exactly:

> **"Plan complete and saved to `{output-path}`. Two execution options:**
>
> **1. Subagent-Driven (recommended)** — Dispatch a fresh sub-agent per task via Mission Control; review between tasks; fast iteration.
>
> **2. Inline Execution** — Execute tasks in this session using the executing-plans skill; batch execution with checkpoints.
>
> **Which approach?"**

**If Subagent-Driven is chosen:**
- Dispatch a sub-agent via Mission Control for Task 1.
- Provide the sub-agent with: the full plan artifact path, Task 1 file list, and Task 1 step list.
- After Task 1 completion, review the diff artifact, then dispatch the next sub-agent.

**If Inline Execution is chosen:**
- Proceed task-by-task using the executing-plans skill in this session.
- Generate a checkpoint artifact after each task batch for human review.
