#!/usr/bin/env bash
# threat_classify.sh v1.0.0 — Deterministic attack classifier for red team
# Invoke with --help first to validate runtime.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
threat_classify.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/threat_classify.sh [OPTIONS]

REQUIRED:
    --thesis <string>                  Verbatim thesis statement
    --attack-type <type>               EMPIRICAL | STRUCTURAL | FRAMING
    --conclusion-addressed <answer>    YES | NO | PARTIALLY

EOF
    exit 0
}

version() { echo "threat_classify.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

THESIS=""; ATTACK_TYPE=""; SECONDARY=""; CONCLUSION_ADDRESSED=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)                  usage ;;
        --version)               version ;;
        --thesis)                THESIS="$2";               shift 2 ;;
        --attack-type)           ATTACK_TYPE="$2";          shift 2 ;;
        --secondary-attacks)     SECONDARY="$2";            shift 2 ;;
        --conclusion-addressed)  CONCLUSION_ADDRESSED="$2"; shift 2 ;;
        *) echo "{\"status\":\"ERROR\",\"message\":\"Unknown option: $1\"}" >&2; exit 1 ;;
    esac
done

[[ -z "$THESIS" ]]               && { echo '{"status":"ERROR","message":"--thesis required"}'; exit 1; }
[[ -z "$ATTACK_TYPE" ]]          && { echo '{"status":"ERROR","message":"--attack-type required"}'; exit 1; }
[[ -z "$CONCLUSION_ADDRESSED" ]] && { echo '{"status":"ERROR","message":"--conclusion-addressed required"}'; exit 1; }

[[ ! "$ATTACK_TYPE" =~ ^(EMPIRICAL|STRUCTURAL|FRAMING)$ ]] && \
    { echo '{"status":"ERROR","message":"--attack-type must be EMPIRICAL|STRUCTURAL|FRAMING"}'; exit 2; }

# ── Classification Logic ──────────────────────────────────────────────────────
case "$ATTACK_TYPE" in
    STRUCTURAL) THREAT="HIGH";   RESPONSE="address" ;;
    EMPIRICAL)  THREAT="MEDIUM"; RESPONSE="acknowledge" ;;
    FRAMING)    THREAT="LOW";    RESPONSE="accept" ;;
esac

[[ "$CONCLUSION_ADDRESSED" == "NO" && "$THREAT" != "HIGH" ]] && THREAT="HIGH"

cat <<JSON
{
  "status": "CLASSIFICATION_COMPLETE",
  "threat_level": "${THREAT}",
  "default_response": "${RESPONSE}"
}
JSON
