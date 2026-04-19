#!/usr/bin/env bash
# Logs a learning entry to the project's learnings store.
# Usage: ./learnings_log.sh '<json_payload>'
# Output contract: STATUS: LOGGED | STATUS: ERROR
set -euo pipefail

PAYLOAD="${1:-}"
if [ -z "$PAYLOAD" ]; then
  echo '{"STATUS": "ERROR", "reason": "No payload provided"}'
  exit 1
fi

GSTACK_BIN="${HOME}/.claude/skills/gstack/bin"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$ROOT" ] && [ -d "$ROOT/.claude/skills/gstack/bin" ]; then
  GSTACK_BIN="$ROOT/.claude/skills/gstack/bin"
fi

if "$GSTACK_BIN/gstack-learnings-log" "$PAYLOAD" 2>/dev/null; then
  echo '{"STATUS": "LOGGED"}'
else
  echo '{"STATUS": "ERROR", "reason": "gstack-learnings-log binary not found or failed"}'
fi
