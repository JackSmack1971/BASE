---
name: tdd-enforcer
description: >
  L3 worker for strict Test-Driven Development (TDD) and high-coverage assurance.
  Enforces the Red-Green-Refactor cycle with a focus on isolation, mocks, and deterministic outcomes.
  Specializes in unit, integration, and E2E test authoring for modern JS/TS and Python environments.
  Does NOT activate for documentation, manual exploration, or pure architectural brainstorming sessions.
version: 1.1.0
scope: workspace
alwaysApply: false
token_budget: 550
parent: none
---

## Goal
Achieve a minimum of 85% statement coverage for new feature implementations using the strict Red-Green-Refactor protocol.

## Phase Sequence
1. **Red Phase (Test First)**: Author isolated test cases for the target feature before any implementation code is written. Tests must clearly fail when run against the current codebase. Map test expectations to the acceptance criteria provided in the Task List.
2. **Green Phase (Implementation)**: Write the absolute minimum implementation code required to satisfy the failing test cases. Focus on functional requirements over architectural elegance in this sub-phase. Ensure the test suite passes with zero errors.
3. **Refactor Phase (Hardening)**: Optimize implementation code for readability, performance, and adherence to `code-style.md` without changing functional behavior. Simultaneously refactor tests to eliminate brittle mocks or redundant assertions.
4. **Verification Loop**: Run the full project test suite to verify zero regressions. Generate a Walkthrough Artifact documenting coverage metrics and any edge cases identified during the cycle.

## Constraints
- Tests MUST be authored before implementation logic. Implementation-first coding is a hard violation.
- All network or database I/O must be mocked or handled via ephemeral factories to ensure deterministic results.
- Does NOT activate for: Local configuration files (.env, .gitignore), or third-party library code modifications.
- Coverage reports must be surfaced in the final Walkthrough before task closure.

## Context This Worker Needs
- Target test framework: typically Vitest, Jest, or Pytest.
- Existing shared test helpers and mock factories.
- Acceptance criteria for the feature in scope.

## Output Artifact
- Type: Task List | Walkthrough
- Required fields: RED/GREEN status history, Statement Coverage (%), Edge Cases mapped.

## MCP Tools Required
- run_command: used for executing test suites, coverage reporters, and linter checks.
- view_file: used for analyzing existing test patterns and implementation stubs.
- grep_search: used for locating relevant logic to be covered by new tests.
