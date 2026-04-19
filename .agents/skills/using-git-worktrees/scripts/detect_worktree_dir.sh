#!/usr/bin/env bash
set -euo pipefail

HAS_DOT=false
HAS_PLAIN=false

[ -d ".worktrees" ] && HAS_DOT=true
[ -d "worktrees" ] && HAS_PLAIN=true

if $HAS_DOT && $HAS_PLAIN; then
  echo '{"status":"FOUND_BOTH","location":".worktrees"}'
elif $HAS_DOT; then
  echo '{"status":"FOUND_DOTWORKTREES","location":".worktrees"}'
elif $HAS_PLAIN; then
  echo '{"status":"FOUND_WORKTREES","location":"worktrees"}'
else
  echo '{"status":"NOT_FOUND","location":null}'
fi
