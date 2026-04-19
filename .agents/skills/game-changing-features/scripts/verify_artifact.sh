#!/usr/bin/env bash
# verify_artifact.sh
# Verifies that a 10x strategy artifact was successfully written and is non-empty.
# Usage: ./verify_artifact.sh --path <relative-file-path>
# Returns: JSON with status, path, size_bytes, line_count

set -euo pipefail

ARTIFACT_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)
      ARTIFACT_PATH="$2"
      shift 2
      ;;
    *)
      echo '{"status":"error","message":"Unknown argument: '"$1"'"}'
      exit 1
      ;;
  esac
done

if [[ -z "$ARTIFACT_PATH" ]]; then
  echo '{"status":"error","message":"--path argument is required"}'
  exit 1
fi

if [[ ! -f "$ARTIFACT_PATH" ]]; then
  echo '{"status":"error","message":"Artifact file not found: '"$ARTIFACT_PATH"'"}'
  exit 1
fi

SIZE=$(wc -c < "$ARTIFACT_PATH" | tr -d ' ')
LINES=$(wc -l < "$ARTIFACT_PATH" | tr -d ' ')

if [[ "$SIZE" -lt 100 ]]; then
  echo '{"status":"error","message":"Artifact appears empty or too small ('"$SIZE"' bytes). Analysis may not have been written."}'
  exit 1
fi

echo "{\"status\":\"verified\",\"path\":\"${ARTIFACT_PATH}\",\"size_bytes\":${SIZE},\"line_count\":${LINES}}"
