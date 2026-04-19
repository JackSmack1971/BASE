#!/usr/bin/env bash
# Launches a browser session targeting a URL or Electron app.
# Usage: ./launch_browser.sh --url <url> | --app <app_name> [--session <name>]
# Output: JSON { "status": "ok"|"error", "session": "<name>", "error_detail": "<msg>" }

set -euo pipefail

URL=""
APP=""
SESSION="default-session"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)    URL="$2";     shift 2 ;;
    --app)    APP="$2";     shift 2 ;;
    --session) SESSION="$2"; shift 2 ;;
    *) echo "{\"status\":\"error\",\"session\":null,\"error_detail\":\"Unknown flag: $1\"}"; exit 1 ;;
  esac
done

if [[ -z "$URL" && -z "$APP" ]]; then
  echo '{"status":"error","session":null,"error_detail":"Must provide --url or --app."}'
  exit 1
fi

if [[ -n "$URL" ]]; then
  RESULT=$(agent-browser session start --name "$SESSION" --url "$URL" 2>&1)
else
  RESULT=$(agent-browser session start --name "$SESSION" --app "$APP" 2>&1)
fi

if echo "$RESULT" | grep -qi "error\|fail\|exception"; then
  ESCAPED=$(echo "$RESULT" | tr '"' "'" | tr '\n' ' ')
  echo "{\"status\":\"error\",\"session\":\"${SESSION}\",\"error_detail\":\"${ESCAPED}\"}"
  exit 1
fi

echo "{\"status\":\"ok\",\"session\":\"${SESSION}\",\"error_detail\":null}"
