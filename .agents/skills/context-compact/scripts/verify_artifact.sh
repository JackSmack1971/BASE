#!/usr/bin/env bash
# Verifies that a required artifact exists and is non-empty.
# Usage: ./verify_artifact.sh --path /path/to/artifact

set -euo pipefail

ARTIFACT_PATH=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) ARTIFACT_PATH="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [[ -z "$ARTIFACT_PATH" ]]; then
  echo '{"status": "ERROR", "reason": "No path provided", "size_bytes": 0}'
  exit 1
fi

if [[ ! -f "$ARTIFACT_PATH" ]]; then
  echo "{\"status\": \"ERROR\", \"reason\": \"File not found: ${ARTIFACT_PATH}\", \"size_bytes\": 0}"
  exit 1
fi

SIZE=$(wc -c < "$ARTIFACT_PATH")
if [[ "$SIZE" -eq 0 ]]; then
  echo "{\"status\": \"ERROR\", \"reason\": \"File is empty: ${ARTIFACT_PATH}\", \"size_bytes\": 0}"
  exit 1
fi

echo "{\"status\": \"OK\", \"path\": \"${ARTIFACT_PATH}\", \"size_bytes\": ${SIZE}}"
