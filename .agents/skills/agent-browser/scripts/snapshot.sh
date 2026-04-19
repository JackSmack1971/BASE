#!/usr/bin/env bash
# Retrieves the accessibility-tree snapshot for a live session.
# Usage: ./snapshot.sh --session <name>
# Output: JSON accessibility tree with @eN element refs, or error JSON.

set -euo pipefail

SESSION="default-session"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session) SESSION="$2"; shift 2 ;;
    *) echo "{\"status\":\"error\",\"tree\":null,\"error_detail\":\"Unknown flag: $1\"}"; exit 1 ;;
  esac
done

RESULT=$(agent-browser snapshot --session "$SESSION" --format json 2>&1)

if echo "$RESULT" | grep -qi "error\|not found\|fail"; then
  ESCAPED=$(echo "$RESULT" | tr '"' "'" | tr '\n' ' ')
  echo "{\"status\":\"error\",\"tree\":null,\"error_detail\":\"${ESCAPED}\"}"
  exit 1
fi

echo "$RESULT"
