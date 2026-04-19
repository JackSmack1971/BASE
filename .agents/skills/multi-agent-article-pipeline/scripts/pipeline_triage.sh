#!/usr/bin/env bash
# pipeline_triage.sh — Deterministic triage scorer and config writer
# Invoke with --help first to validate runtime before any pipeline run.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
pipeline_triage.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/pipeline_triage.sh [OPTIONS]

SCORING MODE (required flags):
    --novelty <0-3>             Novelty axis score
    --contention <0-3>          Contentiousness axis score
    --scope <0-3>               Scope axis score
    --expertise <level>         novice | practitioner | expert
    --assumed-knowledge <list>  Comma-separated list of assumed concepts
    --must-explain <list>       Comma-separated list of concepts to define
    --jargon-policy <policy>    define-all | define-subdomain | no-definitions
    --topic <string>            Topic brief (quoted)
    --output <path>             Output JSON path (default: pipeline_config.json)

DELIVERY VERIFICATION MODE:
    --verify-delivery           Switch to delivery verification mode
    --draft <path>              Path to article_draft.md
    --reader-rating <path>      Path to reader_questions.md

OPTIONS:
    --format <type>             json | text (default: json)
    --help                      Display this help
    --version                   Display version

ROUTING TABLE:
    Score 0-3  → SIMPLE   | dialectic: off | red_team: off | budget: 3000
    Score 4-6  → STANDARD | dialectic: on  | red_team: off | budget: 5000
    Score 7-9  → COMPLEX  | dialectic: on  | red_team: on  | budget: 8000

OUTPUT (JSON):
    {
      "status": "CONFIG_WRITTEN",
      "depth": "SIMPLE|STANDARD|COMPLEX",
      "total_score": N,
      "token_budget": N,
      "dialectic_enabled": true|false,
      "red_team_enabled": true|false,
      "audience": {
        "expertise": "...",
        "assumed_knowledge": [...],
        "must_explain": [...],
        "jargon_policy": "..."
      },
      "topic": "...",
      "config_path": "pipeline_config.json"
    }

EXIT CODES:
    0  Success
    1  Missing required argument
    2  Invalid score or enum value
    3  File write error

EOF
    exit 0
}

version() { echo "pipeline_triage.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

# Defaults
NOVELTY=""
CONTENTION=""
SCOPE_SCORE=""
EXPERTISE=""
ASSUMED=""
MUST_EXPLAIN=""
JARGON=""
TOPIC=""
OUTPUT="pipeline_config.json"
FORMAT="json"
VERIFY_DELIVERY=false
DRAFT_PATH=""
READER_RATING_PATH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)               usage ;;
        --version)            version ;;
        --novelty)            NOVELTY="$2";           shift 2 ;;
        --contention)         CONTENTION="$2";        shift 2 ;;
        --scope)              SCOPE_SCORE="$2";       shift 2 ;;
        --expertise)          EXPERTISE="$2";         shift 2 ;;
        --assumed-knowledge)  ASSUMED="$2";           shift 2 ;;
        --must-explain)       MUST_EXPLAIN="$2";      shift 2 ;;
        --jargon-policy)      JARGON="$2";            shift 2 ;;
        --topic)              TOPIC="$2";             shift 2 ;;
        --output)             OUTPUT="$2";            shift 2 ;;
        --format)             FORMAT="$2";            shift 2 ;;
        --verify-delivery)    VERIFY_DELIVERY=true;   shift ;;
        --draft)              DRAFT_PATH="$2";        shift 2 ;;
        --reader-rating)      READER_RATING_PATH="$2"; shift 2 ;;
        *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

# ── Delivery Verification Mode ──────────────────────────────────────────────
if [[ "$VERIFY_DELIVERY" == true ]]; then
    [[ -z "$DRAFT_PATH" ]] && { echo '{"status":"ERROR","message":"--draft required for verify-delivery"}'; exit 1; }

    RT_STRIPPED=true
    SOURCE_BRACKETS_CLEARED=true
    READER_RATING_POPULATED=true

    if [[ -f "$DRAFT_PATH" ]]; then
        grep -q 'RT-RESPONSE:' "$DRAFT_PATH" 2>/dev/null && RT_STRIPPED=false
        grep -qE '\[Source:' "$DRAFT_PATH" 2>/dev/null && SOURCE_BRACKETS_CLEARED=false
    fi

    if [[ -n "$READER_RATING_PATH" && -f "$READER_RATING_PATH" ]]; then
        grep -qi 'pending simulation\|placeholder' "$READER_RATING_PATH" 2>/dev/null \
            && READER_RATING_POPULATED=false
    elif [[ -n "$READER_RATING_PATH" ]]; then
        READER_RATING_POPULATED=false
    fi

    OVERALL="DELIVERY_READY"
    [[ "$RT_STRIPPED" == false || "$SOURCE_BRACKETS_CLEARED" == false || \
       "$READER_RATING_POPULATED" == false ]] && OVERALL="DELIVERY_BLOCKED"

    cat <<JSON
{
  "status": "${OVERALL}",
  "rt_markers_stripped": ${RT_STRIPPED},
  "source_brackets_cleared": ${SOURCE_BRACKETS_CLEARED},
  "reader_rating_populated": ${READER_RATING_POPULATED}
}
JSON
    exit 0
fi

# ── Scoring Mode Validation ──────────────────────────────────────────────────
for var in NOVELTY CONTENTION SCOPE_SCORE; do
    name=$(echo "$var" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
    val="${!var}"
    [[ -z "$val" ]] && { echo "{\"status\":\"ERROR\",\"message\":\"--$name is required\"}"; exit 1; }
    [[ ! "$val" =~ ^[0-3]$ ]] && { echo "{\"status\":\"ERROR\",\"message\":\"--$name must be 0-3\"}"; exit 2; }
done

[[ -z "$EXPERTISE" ]] && { echo '{"status":"ERROR","message":"--expertise is required"}'; exit 1; }
[[ ! "$EXPERTISE" =~ ^(novice|practitioner|expert)$ ]] && \
    { echo '{"status":"ERROR","message":"--expertise must be novice|practitioner|expert"}'; exit 2; }

[[ -z "$JARGON" ]] && { echo '{"status":"ERROR","message":"--jargon-policy is required"}'; exit 1; }
[[ ! "$JARGON" =~ ^(define-all|define-subdomain|no-definitions)$ ]] && \
    { echo '{"status":"ERROR","message":"--jargon-policy must be define-all|define-subdomain|no-definitions"}'; exit 2; }

[[ -z "$TOPIC" ]] && { echo '{"status":"ERROR","message":"--topic is required"}'; exit 1; }

# ── Compute Routing ──────────────────────────────────────────────────────────
TOTAL=$(( NOVELTY + CONTENTION + SCOPE_SCORE ))

if (( TOTAL <= 3 )); then
    DEPTH="SIMPLE"; DIALECTIC=false; RED_TEAM=false; BUDGET=3000
elif (( TOTAL <= 6 )); then
    DEPTH="STANDARD"; DIALECTIC=true; RED_TEAM=false; BUDGET=5000
else
    DEPTH="COMPLEX"; DIALECTIC=true; RED_TEAM=true; BUDGET=8000
fi

# ── Write Config ─────────────────────────────────────────────────────────────
IFS=',' read -ra ASSUMED_ARR  <<< "${ASSUMED:-}"
IFS=',' read -ra EXPLAIN_ARR  <<< "${MUST_EXPLAIN:-}"

# Helper to format array to JSON
to_json_array() {
    local arr=("$@")
    local out=""
    for i in "${!arr[@]}"; do
        out+="\"${arr[$i]}\""
        [[ $i -lt $(( ${#arr[@]} - 1 )) ]] && out+=","
    done
    echo "$out"
}

assumed_json=$(to_json_array "${ASSUMED_ARR[@]:-}")
explain_json=$(to_json_array "${EXPLAIN_ARR[@]:-}")

CONFIG_JSON=$(cat <<JSON
{
  "status": "CONFIG_WRITTEN",
  "depth": "${DEPTH}",
  "total_score": ${TOTAL},
  "scores": { "novelty": ${NOVELTY}, "contention": ${CONTENTION}, "scope": ${SCOPE_SCORE} },
  "token_budget": ${BUDGET},
  "dialectic_enabled": ${DIALECTIC},
  "red_team_enabled": ${RED_TEAM},
  "audience": {
    "expertise": "${EXPERTISE}",
    "assumed_knowledge": [${assumed_json}],
    "must_explain": [${explain_json}],
    "jargon_policy": "${JARGON}"
  },
  "topic": "${TOPIC}",
  "conflict_handling": {},
  "config_path": "${OUTPUT}"
}
JSON
)

echo "$CONFIG_JSON" > "$OUTPUT" || { echo "{\"status\":\"ERROR\",\"message\":\"Failed to write $OUTPUT\"}"; exit 3; }
echo "$CONFIG_JSON"
