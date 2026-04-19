#!/usr/bin/env bash
set -euo pipefail

WORKTREE_PATH=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) WORKTREE_PATH="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$WORKTREE_PATH" ]; then
  echo '{"status":"ERROR","message":"--path is required"}'
  exit 1
fi

cd "$WORKTREE_PATH"

run_tests() {
  local CMD="$1"
  if OUTPUT=$(eval "$CMD" 2>&1); then
    COUNT=$(echo "$OUTPUT" | grep -oE '[0-9]+ (passing|tests? ok|passed)' | grep -oE '[0-9]+' | head -1 || echo "unknown")
    echo "{\"status\":\"TESTS_PASSED\",\"count\":\"$COUNT\",\"failures\":0}"
  else
    SUMMARY=$(echo "$OUTPUT" | tail -5 | tr '"' "'" | tr '\n' ' ')
    echo "{\"status\":\"TESTS_FAILED\",\"count\":\"unknown\",\"failures\":\"unknown\",\"output\":\"$SUMMARY\"}"
  fi
  exit 0
}

[ -f "package.json" ] && grep -q '"test"' package.json && run_tests "npm test"
[ -f "Cargo.toml" ]   && run_tests "cargo test"
[ -f "pytest.ini" ] || [ -f "pyproject.toml" ] && command -v pytest &>/dev/null && run_tests "pytest"
[ -f "go.mod" ]       && run_tests "go test ./..."

echo '{"status":"NO_TEST_RUNNER","count":0,"failures":0}'
