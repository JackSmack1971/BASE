#!/usr/bin/env bash
set -euo pipefail

PREF=$(grep -iE "worktree.*director" AGENTS.md 2>/dev/null | head -1 || true)

if [ -n "$PREF" ]; then
  CLEAN=$(echo "$PREF" | sed 's/[^a-zA-Z0-9_.~\/-]//g')
  echo "{\"status\":\"PREFERENCE_FOUND\",\"preference\":\"$CLEAN\"}"
else
  echo '{"status":"NO_PREFERENCE","preference":null}'
fi
