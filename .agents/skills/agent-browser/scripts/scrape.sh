#!/usr/bin/env bash
# Extracts text content from matching DOM elements.
# Usage: ./scrape.sh --session <name> --selector <css_selector>
# Output: JSON { "status": "ok"|"error", "data": [...], "count": N, "error_detail": "<msg>" }

set -euo pipefail

SESSION="default-session"
SELECTOR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)  SESSION="$2";   shift 2 ;;
    --selector) SELECTOR="$2";  shift 2 ;;
    *) echo "{\"status\":\"error\",\"data\":null,\"count\":0,\"error_detail\":\"Unknown flag: $1\"}"; exit 1 ;;
  esac
done

if [[ -z "$SELECTOR" ]]; then
  echo '{"status":"error","data":null,"count":0,"error_detail":"--selector is required."}'
  exit 1
fi

RESULT=$(agent-browser scrape --session "$SESSION" --selector "$SELECTOR" --format json 2>&1)

if echo "$RESULT" | grep -qi "error\|fail\|exception"; then
  ESCAPED=$(echo "$RESULT" | tr '"' "'" | tr '\n' ' ')
  echo "{\"status\":\"error\",\"data\":null,\"count\":0,\"error_detail\":\"${ESCAPED}\"}"
  exit 1
fi

echo "$RESULT"
