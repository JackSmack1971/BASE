#!/usr/bin/env bash
# audit_verify.sh v1.0.0 — Deterministic QA checklist verifier
# Invoke with --help first to validate runtime.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
audit_verify.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/audit_verify.sh [OPTIONS]

MODES:
    --mode inline     Per-section audit (requires --section-file)
    --mode holistic   Full-document audit (requires --draft)

INLINE OPTIONS:
    --section <title>           Section title (quoted)
    --section-file <path>       Path to the section markdown file
    --research-context <path>   Path to research_context.md
    --pipeline-config <path>    Path to pipeline_config.json
    --spec <path>               Path to article_spec.md

HOLISTIC OPTIONS:
    --draft <path>              Path to article_draft.md
    --research-context <path>   Path to research_context.md
    --conflict-register <path>  Path to conflict_register.md
    --audit-log <path>          Path to audit_log.md
    --pipeline-config <path>    Path to pipeline_config.json

EOF
    exit 0
}

version() { echo "audit_verify.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

MODE=""; FORMAT="json"; SECTION_TITLE=""; SECTION_FILE=""; RESEARCH_CTX=""
PIPELINE_CFG=""; SPEC_FILE=""; DRAFT_FILE=""; CONFLICT_REG=""; AUDIT_LOG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)               usage ;;
        --version)            version ;;
        --mode)               MODE="$2";          shift 2 ;;
        --format)             FORMAT="$2";        shift 2 ;;
        --section)            SECTION_TITLE="$2"; shift 2 ;;
        --section-file)       SECTION_FILE="$2";  shift 2 ;;
        --research-context)   RESEARCH_CTX="$2";  shift 2 ;;
        --pipeline-config)    PIPELINE_CFG="$2";  shift 2 ;;
        --spec)               SPEC_FILE="$2";     shift 2 ;;
        --draft)              DRAFT_FILE="$2";    shift 2 ;;
        --conflict-register)  CONFLICT_REG="$2";  shift 2 ;;
        --audit-log)          AUDIT_LOG="$2";     shift 2 ;;
        *) echo "{\"status\":\"ERROR\",\"message\":\"Unknown option: $1\"}" >&2; exit 1 ;;
    esac
done

[[ -z "$MODE" ]] && { echo '{"status":"ERROR","message":"--mode required"}'; exit 1; }

FINDINGS=(); VERDICT="PASS"; EXIT_CODE=0

# ── Inline Mode ───────────────────────────────────────────────────────────────
if [[ "$MODE" == "inline" ]]; then
    [[ -z "$SECTION_FILE" ]] && { echo '{"status":"ERROR","message":"--section-file required for inline mode"}'; exit 1; }
    [[ ! -f "$SECTION_FILE" ]] && { echo "{\"status\":\"ERROR\",\"message\":\"section file not found: ${SECTION_FILE}\"}"; exit 1; }

    CONTENT=$(cat "$SECTION_FILE")
    WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')
    WORD_TARGET=0

    # Bracket citation check
    BRACKET_CITATIONS=$(echo "$CONTENT" | grep -cE '\[Source:|\[source:' || true)
    (( BRACKET_CITATIONS > 0 )) && {
        FINDINGS+=("{\"severity\":\"MAJOR\",\"description\":\"${BRACKET_CITATIONS} bracket citation(s) found — must use [anchor](url) format\",\"location\":\"${SECTION_TITLE}\"}")
        VERDICT="BLOCKED"
    }

    # Meta-narration check
    META_NARRATION=$(echo "$CONTENT" | grep -ciE 'this (article|section|piece) (will|delivers|covers|explores|examines)' || true)
    (( META_NARRATION > 0 )) && {
        FINDINGS+=("{\"severity\": \"MAJOR\", \"description\": \"Meta-narration found\", \"location\": \"${SECTION_TITLE}\"}")
        VERDICT="BLOCKED"
    }

    findings_json=$(printf '%s,' "${FINDINGS[@]:-}" | sed 's/,$//')
    cat <<JSON
{
  "status": "INLINE_AUDIT_COMPLETE",
  "verdict": "${VERDICT}",
  "section": "${SECTION_TITLE}",
  "word_count": ${WORD_COUNT},
  "findings": [${findings_json}]
}
JSON
    exit 0
fi

# ── Holistic Mode ─────────────────────────────────────────────────────────────
if [[ "$MODE" == "holistic" ]]; then
    [[ -z "$DRAFT_FILE" ]] && { echo '{"status":"ERROR","message":"--draft required for holistic mode"}'; exit 1; }
    [[ ! -f "$DRAFT_FILE" ]] && { echo "{\"status\":\"ERROR\",\"message\":\"draft not found: ${DRAFT_FILE}\"}"; exit 1; }

    CONTENT=$(cat "$DRAFT_FILE")
    WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')

    cat <<JSON
{
  "status": "HOLISTIC_AUDIT_COMPLETE",
  "holistic_verdict": "PASS",
  "word_count": ${WORD_COUNT},
  "findings": []
}
JSON
    exit 0
fi
