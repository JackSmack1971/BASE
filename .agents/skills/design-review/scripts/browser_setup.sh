#!/usr/bin/env bash
# Detects available browser for the design-review skill.
# Priority: Antigravity native browser sub-agent → gstack browse binary → NEEDS_SETUP
# Output contract: JSON with BROWSER_TYPE and optional PATH
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

# Check gstack browse binary (Antigravity native browser sub-agent is handled
# at the IDE level — this script only surfaces the gstack fallback path)
BROWSE_PATH=""
if [ -n "$ROOT" ] && [ -x "$ROOT/.claude/skills/gstack/browse/dist/browse" ]; then
  BROWSE_PATH="$ROOT/.claude/skills/gstack/browse/dist/browse"
elif [ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ]; then
  BROWSE_PATH="$HOME/.claude/skills/gstack/browse/dist/browse"
fi

if [ -n "$BROWSE_PATH" ]; then
  echo "{\"STATUS\": \"OK\", \"GSTACK_BROWSER\": \"$BROWSE_PATH\", \"note\": \"Use Antigravity native browser sub-agent as primary; gstack binary as fallback\"}"
else
  echo "{\"STATUS\": \"NEEDS_SETUP\", \"GSTACK_BROWSER\": null, \"note\": \"Run: cd ~/.claude/skills/gstack && ./setup\"}"
fi
