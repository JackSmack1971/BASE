#!/usr/bin/env bash
# init_session.sh
# Initializes a 10x strategy session artifact directory and determines the next session number.
# Usage: ./init_session.sh --area <product-or-area>
# Returns: JSON with output_path, session_number, status

set -euo pipefail

AREA=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --area)
      AREA="$2"
      shift 2
      ;;
    *)
      echo '{"status":"error","message":"Unknown argument: '"$1"'"}' 
      exit 1
      ;;
  esac
done

if [[ -z "$AREA" ]]; then
  echo '{"status":"error","message":"--area argument is required"}'
  exit 1
fi

# Sanitize area name: lowercase, replace spaces with hyphens, strip special chars
SAFE_AREA=$(echo "$AREA" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')

OUTPUT_DIR=".agents/docs/ai/${SAFE_AREA}/10x"
mkdir -p "$OUTPUT_DIR"

# Determine next session number
SESSION_N=1
if ls "${OUTPUT_DIR}"/session-*.md 1>/dev/null 2>&1; then
  LAST=$(ls "${OUTPUT_DIR}"/session-*.md | grep -oP 'session-\K[0-9]+' | sort -n | tail -1)
  SESSION_N=$(( LAST + 1 ))
fi

OUTPUT_PATH="${OUTPUT_DIR}/session-${SESSION_N}.md"

# Verify directory is writable
if [[ ! -w "$OUTPUT_DIR" ]]; then
  echo '{"status":"error","message":"Output directory is not writable: '"$OUTPUT_DIR"'"}'
  exit 1
fi

echo "{\"status\":\"ready\",\"session_number\":${SESSION_N},\"output_path\":\"${OUTPUT_PATH}\",\"area\":\"${SAFE_AREA}\"}"
