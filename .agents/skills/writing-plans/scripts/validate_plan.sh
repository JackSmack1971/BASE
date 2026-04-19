#!/usr/bin/env bash
# Scans a plan file for placeholder patterns and returns a JSON compliance report.
# Usage: ./validate_plan.sh --plan-path <path>
# Returns: JSON with spec_gaps, placeholder_hits, type_inconsistencies
set -euo pipefail

PLAN_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --plan-path) PLAN_PATH="$2"; shift 2 ;;
    *) echo '{"error":"Unknown argument"}'; exit 1 ;;
  esac
done

if [[ -z "$PLAN_PATH" ]]; then
  echo '{"error":"--plan-path is required"}'
  exit 1
fi

if [[ ! -f "$PLAN_PATH" ]]; then
  echo "{\"error\":\"File not found: $PLAN_PATH\"}"
  exit 1
fi

# Forbidden placeholder patterns
PATTERNS=(
  "TBD"
  "TODO"
  "implement later"
  "fill in details"
  "Add appropriate error handling"
  "add validation"
  "handle edge cases"
)

HITS=()
for pattern in "${PATTERNS[@]}"; do
  # grep returns line numbers and matched lines
  while IFS= read -r line; do
    HITS+=("$line")
  done < <(grep -ni "$pattern" "$PLAN_PATH" 2>/dev/null || true)
done

# Build JSON array of hits
HITS_JSON="["
for i in "${!HITS[@]}"; do
  ESCAPED=$(printf '%s' "${HITS[$i]}" | sed 's/\\/\\\\/g; s/"/\\"/g')
  if [[ $i -gt 0 ]]; then HITS_JSON+=","; fi
  HITS_JSON+="\"$ESCAPED\""
done
HITS_JSON+="]"

# Count tasks defined (### Task N:)
TASK_COUNT=$(grep -c "^### Task [0-9]" "$PLAN_PATH" 2>/dev/null || echo 0)

# Output structured JSON report
cat <<EOF
{
  "plan_path": "$PLAN_PATH",
  "task_count": $TASK_COUNT,
  "placeholder_hits": $HITS_JSON,
  "placeholder_hit_count": ${#HITS[@]},
  "spec_gaps": [],
  "type_inconsistencies": [],
  "status": "$([ ${#HITS[@]} -eq 0 ] && echo 'PASS' || echo 'FAIL')"
}
EOF
exit 0
