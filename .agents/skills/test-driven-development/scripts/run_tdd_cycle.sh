#!/usr/bin/env bash
# TDD Cycle Verification Script — Antigravity Code Mode
# Returns structured JSON signals for deterministic stage gating.
# Usage: ./run_tdd_cycle.sh --test-path <path> --stage <red|green|refactor>

set -euo pipefail

TEST_PATH=""
STAGE=""

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test-path) TEST_PATH="$2"; shift 2 ;;
    --stage)     STAGE="$2";     shift 2 ;;
    --help)
      echo "Usage: $0 --test-path <path> --stage <red|green|refactor>"
      exit 0
      ;;
    *) echo "{\"error\": \"Unknown argument: $1\"}"; exit 1 ;;
  esac
done

# --- Input Validation ---
if [[ -z "$TEST_PATH" || -z "$STAGE" ]]; then
  echo '{"stage_result": "ERROR", "reason": "Missing --test-path or --stage argument"}'
  exit 1
fi

if [[ ! -f "$TEST_PATH" ]]; then
  echo "{\"stage_result\": \"ERROR\", \"reason\": \"Test file not found: $TEST_PATH\"}"
  exit 1
fi

if [[ "$STAGE" != "red" && "$STAGE" != "green" && "$STAGE" != "refactor" ]]; then
  echo "{\"stage_result\": \"ERROR\", \"reason\": \"Invalid stage: $STAGE. Must be red, green, or refactor\"}"
  exit 1
fi

# --- Helper: JSON Escape ---
# Replaces jq -Rs . with Python for broader compatibility
json_escape() {
  python -c "import sys, json; print(json.dumps(sys.stdin.read()))"
}

# --- Detect Test Runner ---
RUNNER=""
if [[ -f "package.json" ]]; then
  if grep -q '"vitest"' package.json 2>/dev/null; then
    RUNNER="npx vitest run"
  elif grep -q '"jest"' package.json 2>/dev/null; then
    RUNNER="npx jest"
  fi
fi

if [[ -z "$RUNNER" ]]; then
  echo '{"stage_result": "ERROR", "reason": "No supported test runner (jest/vitest) found in package.json"}'
  exit 1
fi

# --- Execute Target Test ---
TARGET_OUTPUT=$(${RUNNER} "$TEST_PATH" --reporter=verbose 2>&1 || true)
TARGET_EXIT=$?

# --- Execute Full Suite (for regression detection at green/refactor) ---
FULL_OUTPUT=""
FULL_EXIT=0
if [[ "$STAGE" == "green" || "$STAGE" == "refactor" ]]; then
  FULL_OUTPUT=$(${RUNNER} --reporter=verbose 2>&1 || true)
  FULL_EXIT=$?
fi

# --- Stage-Specific Signal Logic ---
case "$STAGE" in

  red)
    if echo "$TARGET_OUTPUT" | grep -qiE "PASS|✓|passed"; then
      ESCAPED_OUTPUT=$(echo "$TARGET_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"PASS_UNEXPECTED\", \"stage\": \"red\", \"detail\": \"Test passed immediately — it is testing existing behavior or is incorrectly written.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    elif echo "$TARGET_OUTPUT" | grep -qiE "FAIL|✗|failed|error"; then
      ESCAPED_OUTPUT=$(echo "$TARGET_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"FAIL_CORRECT\", \"stage\": \"red\", \"detail\": \"Test fails as expected. Feature is confirmed missing. Proceed to GREEN.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    else
      ESCAPED_OUTPUT=$(echo "$TARGET_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"ERROR\", \"stage\": \"red\", \"detail\": \"Could not parse test runner output.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    fi
    ;;

  green)
    TARGET_PASS=$(echo "$TARGET_OUTPUT" | grep -cE "PASS|✓|passed" || true)
    FULL_FAIL=$(echo "$FULL_OUTPUT" | grep -cE "FAIL|✗|failed" || true)

    if [[ "$TARGET_PASS" -gt 0 && "$FULL_FAIL" -eq 0 ]]; then
      ESCAPED_OUTPUT=$(echo "$FULL_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"ALL_PASS\", \"stage\": \"green\", \"detail\": \"Target test passes. No regressions detected. Proceed to REFACTOR.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    elif [[ "$TARGET_PASS" -eq 0 ]]; then
      ESCAPED_OUTPUT=$(echo "$TARGET_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"TARGET_FAIL\", \"stage\": \"green\", \"detail\": \"Target test still failing. Fix implementation only.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    else
      ESCAPED_OUTPUT=$(echo "$FULL_OUTPUT" | tail -20 | json_escape)
      echo "{\"stage_result\": \"REGRESSION\", \"stage\": \"green\", \"detail\": \"Target passes but $FULL_FAIL other test(s) now failing. Fix regression before proceeding.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    fi
    ;;

  refactor)
    FULL_FAIL=$(echo "$FULL_OUTPUT" | grep -cE "FAIL|✗|failed" || true)

    if [[ "$FULL_FAIL" -eq 0 ]]; then
      ESCAPED_OUTPUT=$(echo "$FULL_OUTPUT" | tail -10 | json_escape)
      echo "{\"stage_result\": \"ALL_PASS\", \"stage\": \"refactor\", \"detail\": \"All tests passing after refactor. TDD cycle complete. Generate Completion Artifact.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    else
      ESCAPED_OUTPUT=$(echo "$FULL_OUTPUT" | tail -20 | json_escape)
      echo "{\"stage_result\": \"REGRESSION\", \"stage\": \"refactor\", \"detail\": \"Refactor broke $FULL_FAIL test(s). Revert last change and re-run.\", \"output_snippet\": $ESCAPED_OUTPUT}"
    fi
    ;;

esac
