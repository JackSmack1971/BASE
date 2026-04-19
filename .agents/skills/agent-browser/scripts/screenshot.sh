#!/usr/bin/env bash
# Takes a full-page screenshot of the current session state.
# Usage: ./screenshot.sh --session <name> --out <filepath.png>
# Output: JSON { "status": "ok"|"error", "path": "<filepath>", "error_detail": "<msg>" }

set -euo pipefail

SESSION="default-session"
OUT="./screenshots/capture.png"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session) SESSION="$2"; shift 2 ;;
    --out)     OUT="$2";     shift 2 ;;
    *) echo "{\"status\":\"error\",\"path\":null,\"error_detail\":\"Unknown flag: $1\"}"; exit 1 ;;
  esac
done

mkdir -p "$(dirname "$OUT")"
RESULT=$(agent-browser screenshot --session "$SESSION" --output "$OUT" 2>&1)

if echo "$RESULT" | grep -qi "error\|fail"; then
  ESCAPED=$(echo "$RESULT" | tr '"' "'" | tr '\n' ' ')
  echo "{\"status\":\"error\",\"path\":null,\"error_detail\":\"${ESCAPED}\"}"
  exit 1
fi

if [[ ! -f "$OUT" ]]; then
  echo "{\"status\":\"error\",\"path\":null,\"error_detail\":\"Screenshot file not created at ${OUT}.\"}"
  exit 1
fi

echo "{\"status\":\"ok\",\"path\":\"${OUT}\",\"error_detail\":null}"
