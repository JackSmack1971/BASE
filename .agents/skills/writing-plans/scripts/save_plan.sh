#!/usr/bin/env bash
# Saves the generated plan to the specified path.
# Usage: ./save_plan.sh --path <output-path> --content <plan-content>
# Returns: STATUS: SAVED or ERROR: <reason>
set -euo pipefail

PATH_ARG=""
CONTENT_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)    PATH_ARG="$2";    shift 2 ;;
    --content) CONTENT_ARG="$2"; shift 2 ;;
    *) echo "ERROR: Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ -z "$PATH_ARG" ]]; then
  echo "ERROR: --path is required"
  exit 1
fi

if [[ -z "$CONTENT_ARG" ]]; then
  echo "ERROR: --content is required"
  exit 1
fi

# Create parent directories if they don't exist
DIR=$(dirname "$PATH_ARG")
mkdir -p "$DIR" || { echo "ERROR: Could not create directory: $DIR"; exit 1; }

# Write content to file
printf '%s' "$CONTENT_ARG" > "$PATH_ARG" || { echo "ERROR: Could not write to: $PATH_ARG"; exit 1; }

# Verify file exists and is non-empty
if [[ -s "$PATH_ARG" ]]; then
  echo "STATUS: SAVED"
  echo "PATH: $PATH_ARG"
  exit 0
else
  echo "ERROR: File was not written or is empty: $PATH_ARG"
  exit 1
fi
