#!/usr/bin/env bash
# Performs a single browser interaction: click, fill, navigate, or press.
# Usage: ./interact.sh --session <name> --action <click|fill|navigate|press> --selector <@eN|css> [--value "<text>"]
# Output: JSON { "status": "ok"|"error", "result": "success"|null, "error_detail": "<msg>" }

set -euo pipefail

SESSION="default-session"
ACTION=""
SELECTOR=""
VALUE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)  SESSION="$2";   shift 2 ;;
    --action)   ACTION="$2";    shift 2 ;;
    --selector) SELECTOR="$2";  shift 2 ;;
    --value)    VALUE="$2";     shift 2 ;;
    *) echo "{\"status\":\"error\",\"result\":null,\"error_detail\":\"Unknown flag: $1\"}"; exit 1 ;;
  esac
done

if [[ -z "$ACTION" || -z "$SELECTOR" ]]; then
  echo '{"status":"error","result":null,"error_detail":"--action and --selector are required."}'
  exit 1
fi

case "$ACTION" in
  click)    RESULT=$(agent-browser click --session "$SESSION" --ref "$SELECTOR" 2>&1) ;;
  fill)     RESULT=$(agent-browser fill  --session "$SESSION" --ref "$SELECTOR" --value "$VALUE" 2>&1) ;;
  navigate) RESULT=$(agent-browser navigate --session "$SESSION" --url "$SELECTOR" 2>&1) ;;
  press)    RESULT=$(agent-browser press --session "$SESSION" --key "$SELECTOR" 2>&1) ;;
  *)
    echo "{\"status\":\"error\",\"result\":null,\"error_detail\":\"Unknown action: ${ACTION}. Use click|fill|navigate|press.\"}"
    exit 1 ;;
esac

if echo "$RESULT" | grep -qi "error\|fail\|exception"; then
  ESCAPED=$(echo "$RESULT" | tr '"' "'" | tr '\n' ' ')
  echo "{\"status\":\"error\",\"result\":null,\"error_detail\":\"${ESCAPED}\"}"
  exit 1
fi

echo "{\"status\":\"ok\",\"result\":\"success\",\"error_detail\":null}"
