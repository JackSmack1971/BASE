#!/usr/bin/env bash
# Phase 4: Generates the Compaction Summary Artifact. Writes to knowledge dir.
# Usage: ./compaction_audit.sh --session-id compact_123 --knowledge-dir /path

set -euo pipefail

SESSION_ID="compact_unknown"
KNOWLEDGE_DIR=".gemini/antigravity/knowledge"
TOKENS_BEFORE=0
TOKENS_EVICTED=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session-id) SESSION_ID="$2"; shift 2 ;;
    --knowledge-dir) KNOWLEDGE_DIR="$2"; shift 2 ;;
    --tokens-before) TOKENS_BEFORE="$2"; shift 2 ;;
    --tokens-evicted) TOKENS_EVICTED="$2"; shift 2 ;;
    *) shift ;;
  esac
done

TOKENS_RETAINED=$(( TOKENS_BEFORE - TOKENS_EVICTED ))
if [[ "$TOKENS_BEFORE" -gt 0 ]]; then
  REDUCTION_PCT=$(echo "scale=1; $TOKENS_EVICTED * 100 / $TOKENS_BEFORE" | bc)
else
  REDUCTION_PCT="0"
fi

STATE_PATH="${KNOWLEDGE_DIR}/session-state.md"
SUMMARY_PATH="${KNOWLEDGE_DIR}/compaction_summary_${SESSION_ID}.json"

cat > "$SUMMARY_PATH" <<EOF
{
  "session_id": "${SESSION_ID}",
  "tokens_before": ${TOKENS_BEFORE},
  "tokens_evicted": ${TOKENS_EVICTED},
  "tokens_retained": ${TOKENS_RETAINED},
  "reduction_pct": ${REDUCTION_PCT},
  "blocks_evicted": ["raw_shell_stdout_dumps", "raw_compiler_output", "directory_listings", "redundant_context_repetitions"],
  "metadata_preserved": ["AGENTS.md", "session-state.md"],
  "session_state_path": "${STATE_PATH}",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "status": "COMPACTION_COMPLETE"
}
EOF

# Verify reduction target met
THRESHOLD_MET=$(echo "$REDUCTION_PCT >= 70" | bc -l 2>/dev/null | grep -q "1" && echo 1 || echo 0)
echo "{\"status\": \"OK\", \"summary_path\": \"${SUMMARY_PATH}\", \"reduction_pct\": ${REDUCTION_PCT}, \"threshold_met\": $([ "$THRESHOLD_MET" -eq 1 ] && echo true || echo false)}"
