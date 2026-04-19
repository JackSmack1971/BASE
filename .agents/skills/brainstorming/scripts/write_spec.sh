#!/usr/bin/env bash
# Spec Writer — Antigravity Code Mode
# Writes the validated design spec to the standard path.
# Usage: ./write_spec.sh --topic <topic> [--overwrite]
# Agent must provide spec content via stdin or SPEC_CONTENT env variable.

set -euo pipefail

TOPIC=""
OVERWRITE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --topic)     TOPIC="$2"; shift 2 ;;
    --overwrite) OVERWRITE=true; shift ;;
    --help)
      echo "Usage: $0 --topic <topic> [--overwrite]"
      exit 0
      ;;
    *) echo "{\"write_result\": \"ERROR\", \"reason\": \"Unknown argument: $1\"}"; exit 1 ;;
  esac
done

if [[ -z "$TOPIC" ]]; then
  echo '{"write_result": "ERROR", "reason": "Missing --topic argument"}'
  exit 1
fi

# Sanitize topic for filename
SLUG=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
DATE=$(date +%Y-%m-%d)
SPEC_DIR="docs/superpowers/specs"
SPEC_FILE="${SPEC_DIR}/${DATE}-${SLUG}-design.md"

# Create directory if needed
mkdir -p "$SPEC_DIR"

# Guard against overwrite unless flag set
if [[ -f "$SPEC_FILE" && "$OVERWRITE" == false ]]; then
  echo "{\"write_result\": \"ERROR\", \"reason\": \"Spec file already exists: $SPEC_FILE. Use --overwrite to update.\", \"spec_path\": \"$SPEC_FILE\"}"
  exit 1
fi

# Read spec content from SPEC_CONTENT env var or stdin
if [[ -n "${SPEC_CONTENT:-}" ]]; then
  echo "$SPEC_CONTENT" > "$SPEC_FILE"
else
  cat > "$SPEC_FILE"
fi

echo "{\"write_result\": \"SUCCESS\", \"spec_path\": \"$SPEC_FILE\", \"date\": \"$DATE\", \"slug\": \"$SLUG\"}"
