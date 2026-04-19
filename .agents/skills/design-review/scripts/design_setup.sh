#!/usr/bin/env bash
# Detects gstack design binary for target mockup generation (optional enhancement).
# Output contract: JSON with DESIGN_READY or DESIGN_NOT_AVAILABLE
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

DESIGN_PATH=""
if [ -n "$ROOT" ] && [ -x "$ROOT/.claude/skills/gstack/design/dist/design" ]; then
  DESIGN_PATH="$ROOT/.claude/skills/gstack/design/dist/design"
elif [ -x "$HOME/.claude/skills/gstack/design/dist/design" ]; then
  DESIGN_PATH="$HOME/.claude/skills/gstack/design/dist/design"
fi

BROWSE_PATH=""
if [ -n "$ROOT" ] && [ -x "$ROOT/.claude/skills/gstack/browse/dist/browse" ]; then
  BROWSE_PATH="$ROOT/.claude/skills/gstack/browse/dist/browse"
elif [ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ]; then
  BROWSE_PATH="$HOME/.claude/skills/gstack/browse/dist/browse"
fi

if [ -n "$DESIGN_PATH" ]; then
  echo "{\"STATUS\": \"DESIGN_READY\", \"DESIGN_PATH\": \"$DESIGN_PATH\", \"BROWSE_PATH\": \"${BROWSE_PATH:-null}\"}"
else
  echo "{\"STATUS\": \"DESIGN_NOT_AVAILABLE\", \"note\": \"Skip mockup generation. Fix loop works without it. Install: cd ~/.claude/skills/gstack && ./setup\"}"
fi
