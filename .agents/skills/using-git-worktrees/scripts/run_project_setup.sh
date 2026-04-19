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

run_setup() {
  local TOOL="$1"
  local CMD="$2"
  if OUTPUT=$(eval "$CMD" 2>&1); then
    echo "{\"status\":\"SETUP_COMPLETE\",\"tool\":\"$TOOL\"}"
  else
    SAFE=$(echo "$OUTPUT" | tail -3 | tr '"' "'")
    echo "{\"status\":\"SETUP_FAILED\",\"tool\":\"$TOOL\",\"error\":\"$SAFE\"}"
  fi
  exit 0
}

[ -f "package.json" ]      && run_setup "npm"    "npm install"
[ -f "Cargo.toml" ]        && run_setup "cargo"  "cargo build"
[ -f "pyproject.toml" ]    && run_setup "poetry" "poetry install"
[ -f "requirements.txt" ]  && run_setup "pip"    "pip install -r requirements.txt"
[ -f "go.mod" ]            && run_setup "go"     "go mod download"

echo '{"status":"SETUP_COMPLETE","tool":"none"}'
