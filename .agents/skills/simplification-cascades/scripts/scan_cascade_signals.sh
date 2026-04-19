#!/usr/bin/env bash
# scan_cascade_signals.sh
# Scans a target path for Simplification Cascade signals.
# Returns a structured JSON report for agent consumption.
# Usage: ./scan_cascade_signals.sh --path <TARGET_PATH> [--verify]

set -euo pipefail

TARGET_PATH="."
VERIFY_MODE=false

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)
      TARGET_PATH="$2"
      shift 2
      ;;
    --verify)
      VERIFY_MODE=true
      shift
      ;;
    --help)
      echo "Usage: $0 --path <TARGET_PATH> [--verify]"
      echo "  --path     Directory to scan (default: .)"
      echo "  --verify   Re-score after refactor for post-cascade comparison"
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

# --- Validate Target ---
if [[ ! -d "$TARGET_PATH" ]]; then
  echo "{\"error\": \"Target path does not exist: $TARGET_PATH\", \"cascade_score\": 0}"
  exit 1
fi

# --- Signal Detection ---

# 1. Duplicate patterns: find files with >70% structural similarity via line count proximity
declare -A line_counts
declare -a duplicate_patterns=()
while IFS= read -r file; do
  lc=$(wc -l < "$file" 2>/dev/null || echo 0)
  lc=$(echo "$lc" | tr -d '[:space:]')
  line_counts["$file"]=$lc
done < <(find "$TARGET_PATH" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" \) 2>/dev/null)

# Group files within 15% line count of each other (similarity proxy)
declare -a seen_counts=()
for file in "${!line_counts[@]}"; do
  lc="${line_counts[$file]}"
  for sc in "${seen_counts[@]}"; do
    diff=$(( lc > sc ? lc - sc : sc - lc ))
    threshold=$(( sc / 7 + 1 ))
    if (( diff < threshold && lc > 20 )); then
      duplicate_patterns+=("$file")
      break
    fi
  done
  seen_counts+=("$lc")
done
dup_count=${#duplicate_patterns[@]}

# 2. Special case hotspots: files with high conditional branch density
declare -a special_case_hotspots=()
while IFS= read -r file; do
  branch_count=$(grep -cE '^\s*(if|elif|else if|case|switch|catch|except)\b' "$file" 2>/dev/null || echo 0)
  branch_count=$(echo "$branch_count" | tr -d '[:space:]')
  line_count=$(wc -l < "$file" 2>/dev/null || echo 1)
  line_count=$(echo "$line_count" | tr -d '[:space:]')
  # Flag if >1 branch per 8 lines
  threshold=$(( line_count / 8 ))
  if (( branch_count > threshold && branch_count > 4 )); then
    special_case_hotspots+=("$file")
  fi
done < <(find "$TARGET_PATH" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" \) 2>/dev/null)
sc_count=${#special_case_hotspots[@]}

# 3. Config bloat: config files with >50 keys
declare -a config_bloat_files=()
while IFS= read -r file; do
  key_count=$(grep -cE '^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*[:=]' "$file" 2>/dev/null || echo 0)
  if (( key_count > 50 )); then
    config_bloat_files+=("$file")
  fi
done < <(find "$TARGET_PATH" -type f \( -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" -o -name "*.env*" \) 2>/dev/null)
cb_count=${#config_bloat_files[@]}

# --- Cascade Score Calculation (0-100) ---
raw_score=$(( (dup_count * 15) + (sc_count * 10) + (cb_count * 8) ))
cascade_score=$(( raw_score > 100 ? 100 : raw_score ))

# --- Format JSON Arrays ---
format_json_array() {
  local arr=("$@")
  if [[ ${#arr[@]} -eq 0 ]]; then
    echo "[]"
    return
  fi
  local json="["
  for i in "${!arr[@]}"; do
    json+="\"${arr[$i]}\""
    if (( i < ${#arr[@]} - 1 )); then json+=","; fi
  done
  json+="]"
  echo "$json"
}

dup_json=$(format_json_array "${duplicate_patterns[@]+"${duplicate_patterns[@]}"}")
sc_json=$(format_json_array "${special_case_hotspots[@]+"${special_case_hotspots[@]}"}")
cb_json=$(format_json_array "${config_bloat_files[@]+"${config_bloat_files[@]}"}")

# --- Output ---
SCORE_FIELD="cascade_score"
if [[ "$VERIFY_MODE" == "true" ]]; then
  SCORE_FIELD="post_cascade_score"
fi

cat <<EOF
{
  "scan_target": "$TARGET_PATH",
  "verify_mode": $VERIFY_MODE,
  "duplicate_patterns": $dup_json,
  "special_case_hotspots": $sc_json,
  "config_bloat_files": $cb_json,
  "$SCORE_FIELD": $cascade_score,
  "signal_counts": {
    "duplicate_pattern_files": $dup_count,
    "special_case_hotspot_files": $sc_count,
    "config_bloat_files": $cb_count
  },
  "status": "$([ $cascade_score -gt 0 ] && echo 'SIGNALS_FOUND' || echo 'NO_SIGNALS')"
}
EOF
