#!/usr/bin/env bash
# analyze_commits.sh — Fetches, filters, and categorizes git commits for changelog generation.
# Returns a JSON manifest and writes categorized_commits.json to .tmp/
# Usage: ./analyze_commits.sh [--since DATE] [--from TAG] [--to TAG] [--style PATH] [--output FILE] [--format release|weekly|appstore]

set -euo pipefail

SINCE=""
FROM_TAG=""
TO_TAG=""
STYLE_GUIDE=""
OUTPUT_FILE="CHANGELOG_DRAFT.md"
FORMAT="release"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/.tmp"
mkdir -p "$TMP_DIR"

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --since)   SINCE="$2";       shift 2 ;;
    --from)    FROM_TAG="$2";    shift 2 ;;
    --to)      TO_TAG="$2";      shift 2 ;;
    --style)   STYLE_GUIDE="$2"; shift 2 ;;
    --output)  OUTPUT_FILE="$2"; shift 2 ;;
    --format)  FORMAT="$2";      shift 2 ;;
    *)         echo "{\"status\":\"ERROR\",\"message\":\"Unknown argument: $1\"}"; exit 1 ;;
  esac
done

# --- Validate git repo ---
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo '{"status":"ERROR","message":"Not inside a git repository. Run from project root."}'
  exit 1
fi

# --- Build git log range ---
GIT_RANGE=""
if [[ -n "$FROM_TAG" && -n "$TO_TAG" ]]; then
  GIT_RANGE="${FROM_TAG}..${TO_TAG}"
elif [[ -n "$FROM_TAG" ]]; then
  GIT_RANGE="${FROM_TAG}..HEAD"
elif [[ -n "$SINCE" ]]; then
  GIT_RANGE="--since=\"$SINCE\""
else
  # Default: last 14 days
  SINCE=$(date -d "14 days ago" +%Y-%m-%d 2>/dev/null || date -v-14d +%Y-%m-%d)
  GIT_RANGE="--since=\"$SINCE\""
fi

# --- Fetch commits (hash | subject | body) ---
COMMITS_RAW=$(eval git log $GIT_RANGE --pretty=format:'%H|||%s|||%b---COMMIT_END---' --no-merges 2>/dev/null || true)

COMMIT_COUNT=0
FILTERED_COUNT=0
declare -A CAT_COUNTS=( [features]=0 [improvements]=0 [fixes]=0 [breaking]=0 [security]=0 [internal]=0 )
ENTRIES_JSON="["
FIRST=true

# Noise patterns (internal — exclude from user-facing changelog)
NOISE_PATTERNS="^(chore|ci|build|test|refactor|style|docs\(internal\)|bump version|merge|wip|typo|lint|format)"

while IFS= read -r -d $'\0' BLOCK; do
  [[ -z "$BLOCK" ]] && continue
  COMMIT_COUNT=$((COMMIT_COUNT + 1))

  HASH=$(echo "$BLOCK"  | awk -F'|||' '{print $1}')
  SUBJECT=$(echo "$BLOCK" | awk -F'|||' '{print $2}')
  BODY=$(echo "$BLOCK"    | awk -F'|||' '{print $3}' | tr '\n' ' ')

  # Categorize
  CATEGORY="improvements"
  if echo "$SUBJECT" | grep -qiE "^(feat|feature|add):"; then
    CATEGORY="features"
  elif echo "$SUBJECT" | grep -qiE "^fix:|^bugfix:|^bug:"; then
    CATEGORY="fixes"
  elif echo "$SUBJECT" | grep -qiE "BREAKING CHANGE|!:"; then
    CATEGORY="breaking"
  elif echo "$SUBJECT" | grep -qiE "^security:|^sec:"; then
    CATEGORY="security"
  elif echo "$SUBJECT" | grep -qiE "$NOISE_PATTERNS"; then
    CATEGORY="internal"
  fi

  if [[ "$CATEGORY" == "internal" ]]; then
    CAT_COUNTS[internal]=$((CAT_COUNTS[internal] + 1))
    continue
  fi

  FILTERED_COUNT=$((FILTERED_COUNT + 1))
  CAT_COUNTS[$CATEGORY]=$((CAT_COUNTS[$CATEGORY] + 1))

  # Sanitize for JSON
  SUBJECT_SAFE=$(echo "$SUBJECT" | sed 's/"/\\"/g')
  BODY_SAFE=$(echo "$BODY"    | sed 's/"/\\"/g')
  HASH_SHORT="${HASH:0:8}"

  if [[ "$FIRST" == true ]]; then FIRST=false; else ENTRIES_JSON+=","; fi
  ENTRIES_JSON+="{\"hash\":\"$HASH_SHORT\",\"subject\":\"$SUBJECT_SAFE\",\"body\":\"$BODY_SAFE\",\"category\":\"$CATEGORY\"}"

done < <(echo "$COMMITS_RAW" | awk 'BEGIN{RS="---COMMIT_END---"} NF{printf "%s\0", $0}')

ENTRIES_JSON+="]"

# Write categorized commits
echo "$ENTRIES_JSON" > "$TMP_DIR/categorized_commits.json"

# Style guide check
STYLE_LOADED="false"
if [[ -n "$STYLE_GUIDE" && -f "$STYLE_GUIDE" ]]; then
  STYLE_LOADED="true"
fi

# Write manifest
MANIFEST=$(cat <<EOF
{
  "status": "OK",
  "commit_count": $COMMIT_COUNT,
  "filtered_count": $FILTERED_COUNT,
  "categories": {
    "features": ${CAT_COUNTS[features]},
    "improvements": ${CAT_COUNTS[improvements]},
    "fixes": ${CAT_COUNTS[fixes]},
    "breaking": ${CAT_COUNTS[breaking]},
    "security": ${CAT_COUNTS[security]},
    "internal": ${CAT_COUNTS[internal]}
  },
  "style_guide_loaded": $STYLE_LOADED,
  "output_path": "./$OUTPUT_FILE",
  "raw_categorized_path": "$TMP_DIR/categorized_commits.json",
  "format": "$FORMAT"
}
EOF
)

echo "$MANIFEST" > "$TMP_DIR/manifest.json"
echo "$MANIFEST"
