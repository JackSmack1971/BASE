#!/usr/bin/env bash
# Spec Git Committer — Antigravity Code Mode
# Stages and commits the spec file after writing.
# Usage: ./commit_spec.sh --spec-path <path>

set -euo pipefail

SPEC_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --spec-path) SPEC_PATH="$2"; shift 2 ;;
    --help)
      echo "Usage: $0 --spec-path <path>"
      exit 0
      ;;
    *) echo "{\"commit_result\": \"ERROR\", \"reason\": \"Unknown argument: $1\"}"; exit 1 ;;
  esac
done

if [[ -z "$SPEC_PATH" ]]; then
  echo '{"commit_result": "ERROR", "reason": "Missing --spec-path argument"}'
  exit 1
fi

if [[ ! -f "$SPEC_PATH" ]]; then
  echo "{\"commit_result\": \"ERROR\", \"reason\": \"Spec file not found: $SPEC_PATH\"}"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo '{"commit_result": "ERROR", "reason": "Not inside a git repository"}'
  exit 1
fi

git add "$SPEC_PATH"
COMMIT_MSG="docs: add design spec $(basename "$SPEC_PATH" .md)"
git commit -m "$COMMIT_MSG" 2>&1

echo "{\"commit_result\": \"SUCCESS\", \"spec_path\": \"$SPEC_PATH\", \"commit_message\": \"$COMMIT_MSG\"}"
