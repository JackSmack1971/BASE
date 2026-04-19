#!/usr/bin/env bash
# Measures current session token utilization.
# Returns JSON with utilization_pct and trigger classification.
# Usage: ./measure_tokens.sh [--window-ceiling N]

set -euo pipefail

WINDOW_CEILING=${WINDOW_CEILING:-1000000}
TRIGGER_REASON=${TRIGGER_REASON:-"auto_70pct"}

# Attempt to read token count from Antigravity context metadata if available
# Falls back to estimating from session log size on disk
SESSION_LOG="${HOME}/.config/Antigravity/session_current.pb"
if command -v antigravity-tokens &>/dev/null; then
  SESSION_TOKENS=$(antigravity-tokens --count 2>/dev/null || echo 0)
elif [[ -f "$SESSION_LOG" ]]; then
  # Rough estimate: 1 token ≈ 4 bytes
  BYTES=$(wc -c < "$SESSION_LOG")
  SESSION_TOKENS=$(( BYTES / 4 ))
else
  SESSION_TOKENS=0
  TRIGGER_REASON="manual"
fi

UTILIZATION_PCT=$(echo "scale=2; $SESSION_TOKENS * 100 / $WINDOW_CEILING" | bc 2>/dev/null || echo "0")

cat <<EOF
{
  "session_tokens": $SESSION_TOKENS,
  "window_ceiling": $WINDOW_CEILING,
  "utilization_pct": $UTILIZATION_PCT,
  "trigger_reason": "$TRIGGER_REASON",
  "activation_eligible": $(echo "$UTILIZATION_PCT >= 70" | bc -l 2>/dev/null || echo 0),
  "status": "OK"
}
EOF
