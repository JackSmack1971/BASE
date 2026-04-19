#!/usr/bin/env bash
# Fire-and-forget telemetry logger. Never blocks the skill workflow.
# Usage: ./telemetry_log.sh --skill NAME --outcome success|error|abort
#         --used-browse true|false --session-id ID --start EPOCH
set -euo pipefail

SKILL="design-review"; OUTCOME="unknown"; USED_BROWSE="false"; SESSION_ID=""; TEL_START=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skill) SKILL="$2"; shift 2;;
    --outcome) OUTCOME="$2"; shift 2;;
    --used-browse) USED_BROWSE="$2"; shift 2;;
    --session-id) SESSION_ID="$2"; shift 2;;
    --start) TEL_START="$2"; shift 2;;
    *) shift;;
  esac
done

TEL_END=$(date +%s)
TEL_DUR=$(( TEL_END - TEL_START ))

GSTACK_BIN="${HOME}/.claude/skills/gstack/bin"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$ROOT" ] && [ -d "$ROOT/.claude/skills/gstack/bin" ]; then
  GSTACK_BIN="$ROOT/.claude/skills/gstack/bin"
fi

TEL_SETTING=$("$GSTACK_BIN/gstack-config" get telemetry 2>/dev/null || echo "off")

# Local analytics (always, regardless of setting)
mkdir -p ~/.gstack/analytics
echo "{\"skill\":\"$SKILL\",\"duration_s\":\"$TEL_DUR\",\"outcome\":\"$OUTCOME\",\"browse\":\"$USED_BROWSE\",\"session\":\"$SESSION_ID\",\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
  >> ~/.gstack/analytics/skill-usage.jsonl 2>/dev/null || true

# Timeline completion (non-blocking)
"$GSTACK_BIN/gstack-timeline-log" \
  "{\"skill\":\"$SKILL\",\"event\":\"completed\",\"branch\":\"$(git branch --show-current 2>/dev/null || echo unknown)\",\"outcome\":\"$OUTCOME\",\"duration_s\":\"$TEL_DUR\",\"session\":\"$SESSION_ID\"}" \
  2>/dev/null & disown

# Remote telemetry (opt-in only)
if [ "$TEL_SETTING" != "off" ] && [ -x "$GSTACK_BIN/gstack-telemetry-log" ]; then
  "$GSTACK_BIN/gstack-telemetry-log" \
    --skill "$SKILL" --duration "$TEL_DUR" --outcome "$OUTCOME" \
    --used-browse "$USED_BROWSE" --session-id "$SESSION_ID" \
    2>/dev/null & disown
fi

echo '{"STATUS": "TELEMETRY_LOGGED"}'
