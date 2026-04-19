#!/usr/bin/env bash
# Visual Companion Loader — Antigravity Code Mode
# Loads the visual companion guide into agent context on-demand.
# Only called after user explicitly accepts the Visual Companion offer.

set -euo pipefail

GUIDE_PATH="$(dirname "$0")/../resources/visual-companion.md"

if [[ ! -f "$GUIDE_PATH" ]]; then
  echo "{\"load_result\": \"ERROR\", \"reason\": \"visual-companion.md not found at: $GUIDE_PATH\"}"
  exit 1
fi

CONTENT=$(cat "$GUIDE_PATH")

# Use Python to escape the guide content into a JSON string
ESCAPED_GUIDE=$(echo "$CONTENT" | python3 -c "import sys, json; print(json.dumps(sys.stdin.read()))")

echo "{\"load_result\": \"SUCCESS\", \"guide\": $ESCAPED_GUIDE}"
