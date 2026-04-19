---
name: using-git-worktrees
description: >
  Use this skill to create isolated git worktrees before any feature, fix, or
  refactor work requiring branch isolation from the current workspace.
  MUST BE USED when the user says "set up a worktree", "isolate my branch",
  "create a feature workspace", "I need an isolated environment", or "before
  executing an implementation plan".
  MUST BE USED by orchestrator agents before dispatching parallel sub-agents to
  work on separate features simultaneously.
  Executes smart directory selection, mandatory gitignore safety verification,
  project dependency setup, and baseline test validation — returning a
  fully verified, clean worktree path ready for implementation.
risk: safe
---

# Using Git Worktrees

## Purpose

Creates an isolated git worktree workspace that shares the repository but
operates on a dedicated branch, enabling parallel development, safe
implementation plan execution, and clean baseline verification before work
begins.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an
isolated workspace."

---

## Agent Execution Protocol

Execute all steps in strict sequence. Do not skip steps. Do not proceed past
any step that returns an ERROR status without handling it as described.

---

## Step 1 — Detect Worktree Directory

Execute `./scripts/detect_worktree_dir.sh` using the `run_command` tool.
run_command: ./scripts/detect_worktree_dir.sh

Parse the JSON output:
- `status: "FOUND_DOTWORKTREES"` → Use `.worktrees/` as location. Proceed to Step 2.
- `status: "FOUND_WORKTREES"` → Use `worktrees/` as location. Proceed to Step 2.
- `status: "FOUND_BOTH"` → Use `.worktrees/` (wins by convention). Proceed to Step 2.
- `status: "NOT_FOUND"` → Proceed to Step 1b.

### Step 1b — Check AGENTS.md for Preference

Execute `./scripts/check_agents_md_preference.sh` using the `run_command` tool.
run_command: ./scripts/check_agents_md_preference.sh

Parse output:
- `status: "PREFERENCE_FOUND"`, `preference: "<value>"` → Use that directory. Proceed to Step 2.
- `status: "NO_PREFERENCE"` → Present the following choice to the user and await response before continuing:
No worktree directory found. Where should I create worktrees?

.worktrees/ (project-local, hidden)
~/.config/superpowers/worktrees/<project-name>/ (global location)

Which would you prefer?

---

## Step 2 — Safety Verification (Project-Local Only)

**Skip this step if the selected location is `~/.config/superpowers/worktrees/`.**

For `.worktrees/` or `worktrees/`, execute:
run_command: ./scripts/verify_gitignore.sh --dir <selected-directory>

Parse output:
- `status: "IGNORED"` → Safe. Proceed to Step 3.
- `status: "NOT_IGNORED"` → HALT. Execute the following remediation sequence before continuing:
  1. Add the directory name as a line to `.gitignore` using `run_command`.
  2. Execute `git add .gitignore && git commit -m "chore: ignore worktree directory"` via `run_command`.
  3. Re-run `./scripts/verify_gitignore.sh --dir <selected-directory>` to confirm `status: "IGNORED"`.
  4. Only then proceed to Step 3.

**Why critical:** Committing worktree contents pollutes git history and corrupts repository state.

---

## Step 3 — Detect Project Name and Construct Path

Execute:
run_command: ./scripts/build_worktree_path.sh --location <selected-location> --branch <BRANCH_NAME>

Argument extraction rule: Extract `BRANCH_NAME` from the user's request. If the user says "feature auth" or "auth feature", map to `feature/auth`. If a branch name is explicitly stated, use it verbatim. If no branch name is provided, ask the user before proceeding.

Parse output:
- `status: "PATH_READY"`, `worktree_path: "<full-path>"` → Use this path in Step 4.

---

## Step 4 — Create Worktree

Execute:
run_command: ./scripts/create_worktree.sh --path <worktree_path> --branch <BRANCH_NAME>

Parse output:
- `status: "CREATED"` → Proceed to Step 5.
- `status: "BRANCH_EXISTS"` → Inform user the branch already exists. Ask: "Branch already exists. Create worktree tracking existing branch?" Await confirmation before retrying with `--no-create-branch` flag.
- `status: "ERROR"`, `message: "<error>"` → Report the error message verbatim. Halt and request human review.

---

## Step 5 — Run Project Setup

Execute:
run_command: ./scripts/run_project_setup.sh --path <worktree_path>

This script auto-detects the project type and runs the appropriate dependency installer. Parse output:
- `status: "SETUP_COMPLETE"`, `tool: "<npm|cargo|pip|poetry|go|none>"` → Proceed to Step 6.
- `status: "SETUP_FAILED"`, `tool: "<tool>"`, `error: "<error>"` → Report failure. Ask user whether to proceed without a clean dependency install.

---

## Step 6 — Baseline Test Verification

Execute:
run_command: ./scripts/run_baseline_tests.sh --path <worktree_path>

Parse output:
- `status: "TESTS_PASSED"`, `count: <N>`, `failures: 0` → Proceed to Step 7.
- `status: "NO_TEST_RUNNER"` → Report no test runner detected. Proceed to Step 7 with note.
- `status: "TESTS_FAILED"`, `count: <N>`, `failures: <F>`, `output: "<summary>"` → HALT. Report failures verbatim. Ask: "Pre-existing test failures detected. Proceed anyway or investigate first?"

---

## Step 7 — Generate Completion Artifact

Generate a structured completion report:
Worktree ready at <worktree_path>
Branch: <BRANCH_NAME>
Setup: <tool used or 'none'>
Tests: <N> passing, 0 failures (or 'no runner detected')
Ready to implement <feature-name>

Store this as a Task Completion Artifact. Sub-agent orchestrators may read this artifact to confirm the workspace is ready before dispatching parallel feature agents.

---

## Decision Tree (Quick Reference)

| Condition | Action |
|---|---|
| `.worktrees/` exists | Use it → verify ignored |
| `worktrees/` exists | Use it → verify ignored |
| Both exist | `.worktrees/` wins → verify ignored |
| Neither exists | Check AGENTS.md → ask user |
| Directory not ignored | Add to .gitignore → commit → verify |
| Global path selected | Skip gitignore check |
| Branch name unclear | Ask before proceeding |
| Branch already exists | Ask before using existing |
| Setup fails | Report + ask to proceed |
| Tests fail | Report verbatim + ask to proceed |
| Tests pass | Report count + proceed |

---

## Sub-Agent Compatibility

This skill is designed to be dispatched by a Mission Control orchestrator as a
discrete setup task. After completion, the orchestrator may read the Task
Completion Artifact to confirm readiness before launching parallel feature
agents on the isolated worktree path.

**Upstream callers:** brainstorming (Phase 4), subagent-driven-development,
executing-plans, any skill requiring an isolated workspace.

**Downstream pair:** finishing-a-development-branch (cleanup after work complete).
