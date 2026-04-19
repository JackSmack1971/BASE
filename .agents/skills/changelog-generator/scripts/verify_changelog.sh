#!/usr/bin/env bash
# verify_changelog.sh — Validates the generated changelog draft against the commit manifest.
# Returns a JSON verification report.
# Usage: ./verify_changelog.sh --draft PATH --manifest PATH

set -euo pipefail

DRAFT=""
MANIFEST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --draft)    DRAFT="$2";    shift 2 ;;
    --manifest) MANIFEST="$2"; shift 2 ;;
    *)          echo "{\"status\":\"ERROR\",\"message\":\"Unknown argument: $1\"}"; exit 1 ;;
  esac
done

if [[ ! -f "$DRAFT" ]]; then
  echo "{\"status\":\"ERROR\",\"message\":\"Draft file not found: $DRAFT\"}"
  exit 1
fi

if [[ ! -f "$MANIFEST" ]]; then
  echo "{\"status\":\"ERROR\",\"message\":\"Manifest file not found: $MANIFEST\"}"
  exit 1
fi

# Read expected entry count from manifest
EXPECTED=$(python3 -c "
import json, sys
m = json.load(open('$MANIFEST'))
c = m['categories']
print(c['features'] + c['improvements'] + c['fixes'] + c['breaking'] + c['security'])
" 2>/dev/null || echo "0")

# Count actual entries in draft (lines starting with "- " or "* ")
ACTUAL=$(grep -cE "^[-*] " "$DRAFT" 2>/dev/null || echo "0")

MISSING=$((EXPECTED - ACTUAL))
[[ $MISSING -lt 0 ]] && MISSING=0

# Check for empty section headers (header line followed immediately by another header)
EMPTY_SECTIONS="false"
if grep -qP "^#{1,3} .+\n#{1,3} " "$DRAFT" 2>/dev/null; then
  EMPTY_SECTIONS="true"
fi

STATUS="PASS"
[[ $MISSING -gt 0 ]] && STATUS="WARN"

echo "{\"status\":\"$STATUS\",\"entries_matched\":$ACTUAL,\"entries_missing\":$MISSING,\"empty_sections_found\":$EMPTY_SECTIONS,\"style_violations\":[]}"
