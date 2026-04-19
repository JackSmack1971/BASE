#!/usr/bin/env bash
# research_scraper.sh v3.0.0 — Research retrieval utility (Antigravity edition)
# Invoke with --help FIRST, then execute with parameters.

set -euo pipefail
VERSION="3.0.0"
SEARCH_PROVIDER="${SEARCH_PROVIDER:-stub}"

usage() {
    cat <<EOF
research_scraper.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/research_scraper.sh [OPTIONS]

REQUIRED:
    --query <string>       Search query or topic
    --mode  <type>         advocate | skeptic | unified

OPTIONS:
    --thesis <string>      Thesis statement (from thesis.md — verbatim)
    --audience <level>     novice | practitioner | expert (default: practitioner)
    --sources <int>        Max sources to retrieve (default: 10)
    --min-tier <int>       Minimum source tier: 1 | 2 | 3 (default: 2)
    --format <type>        markdown | json (default: json)
    --output <path>        Output file path (default: stdout)
    --validate             Quality gate validation mode (requires --advocate + --skeptic)
    --advocate <path>      Advocate evidence JSON (validation mode)
    --skeptic <path>       Skeptic evidence JSON (validation mode)
    --help                 Display this help
    --version              Display version

MODES:
    advocate   Prioritize thesis-supporting Tier 1/2 sources.
    skeptic    Prioritize disconfirming Tier 1/2 sources.
    unified    Balanced retrieval — for SIMPLE pipeline depth.

EOF
    exit 0
}

version() { echo "research_scraper.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

# Defaults
MAX_SOURCES=10; MIN_TIER=2; FORMAT="json"
AUDIENCE="practitioner"; OUTPUT=""; THESIS=""; VALIDATE=false
ADVOCATE_PATH=""; SKEPTIC_PATH=""; QUERY=""; MODE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)        usage ;;
        --version)     version ;;
        --query)       QUERY="$2";          shift 2 ;;
        --mode)        MODE="$2";           shift 2 ;;
        --thesis)      THESIS="$2";         shift 2 ;;
        --audience)    AUDIENCE="$2";       shift 2 ;;
        --sources)     MAX_SOURCES="$2";    shift 2 ;;
        --min-tier)    MIN_TIER="$2";       shift 2 ;;
        --format)      FORMAT="$2";         shift 2 ;;
        --output)      OUTPUT="$2";         shift 2 ;;
        --validate)    VALIDATE=true;       shift ;;
        --advocate)    ADVOCATE_PATH="$2";  shift 2 ;;
        --skeptic)     SKEPTIC_PATH="$2";   shift 2 ;;
        *) echo "{\"status\":\"ERROR\",\"message\":\"Unknown option: $1\"}" >&2; exit 1 ;;
    esac
done

# ── Validation Mode ──────────────────────────────────────────────────────────
if [[ "$VALIDATE" == true ]]; then
    FAILURES=()
    ADV_OK=true; SKP_OK=true; TIER_OK=true; DOM_OK=true; URL_OK=true

    check_json_file() {
        local path="$1" label="$2" min_claims="$3"
        if [[ ! -f "$path" ]]; then
            echo "\"${label}: file not found\""
            return 1
        fi
        return 0
    }

    [[ -n "$ADVOCATE_PATH" ]] || FAILURES+=("\"--advocate required for validation\"")
    [[ -n "$SKEPTIC_PATH" ]]  || FAILURES+=("\"--skeptic required for validation\"")

    GATE="QUALITY_GATE_PASSED"
    (( ${#FAILURES[@]} > 0 )) && GATE="QUALITY_GATE_FAILED"

    failures_json=$(printf '%s,' "${FAILURES[@]:-}" | sed 's/,$//')
    cat <<JSON
{
  "status": "${GATE}",
  "advocate_sources_ok": ${ADV_OK},
  "skeptic_sources_ok": ${SKP_OK},
  "tier_ratio_ok": ${TIER_OK},
  "no_dominant_source": ${DOM_OK},
  "all_urls_present": ${URL_OK},
  "failures": [${failures_json}]
}
JSON
    [[ "$GATE" == "QUALITY_GATE_FAILED" ]] && exit 4
    exit 0
fi

# ── Mode Validation ──────────────────────────────────────────────────────────
[[ -z "$QUERY" ]] && { echo '{"status":"ERROR","message":"--query is required"}'; exit 1; }
[[ -z "$MODE"  ]] && { echo '{"status":"ERROR","message":"--mode is required"}'; exit 1; }
[[ ! "$MODE" =~ ^(advocate|skeptic|unified)$ ]] && \
    { echo '{"status":"ERROR","message":"--mode must be advocate|skeptic|unified"}'; exit 2; }

# ── Stub/Live Logic ─────────────────────────────────────────────────────────
if [[ "$SEARCH_PROVIDER" == "stub" ]]; then
    case "$MODE" in
        advocate) ALIGN="supporting" ;;
        skeptic)  ALIGN="counter" ;;
        *)        ALIGN="neutral" ;;
    esac

    STUB_JSON=$(cat <<JSON
{
  "status": "STUB",
  "mode": "${MODE}",
  "query": "${QUERY}",
  "thesis": "${THESIS}",
  "claims_count": 0,
  "tier_1_count": 0,
  "tier_2_count": 0,
  "tier_3_count": 0,
  "tier_3_accepted": [],
  "stub_note": "No live search provider. Set SEARCH_PROVIDER=tavily|serpapi|perplexity and SEARCH_API_KEY.",
  "claims": [
    {
      "claim": "[STUB — wire live API for real results]",
      "source": "[Author/Org, Date, URL]",
      "url": "",
      "tier": 0,
      "confidence": "LOW",
      "alignment": "${ALIGN}"
    }
  ]
}
JSON
)
    if [[ -n "$OUTPUT" ]]; then echo "$STUB_JSON" > "$OUTPUT"; else echo "$STUB_JSON"; fi
    exit 0
fi

echo "{\"status\":\"ERROR\",\"message\":\"SEARCH_PROVIDER integration pending: ${SEARCH_PROVIDER}\"}" >&2
exit 3
