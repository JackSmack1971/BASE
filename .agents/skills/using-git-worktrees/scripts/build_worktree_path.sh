#!/usr/bin/env bash
set -euo pipefail

LOCATION=""
BRANCH=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --location) LOCATION="$2"; shift 2 ;;
    --branch)   BRANCH="$2";   shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$LOCATION" ] || [ -z "$BRANCH" ]; then
  echo '{"status":"ERROR","message":"--location and --branch are required"}'
  exit 1
fi

PROJECT=$(basename "$(git rev-parse --show-toplevel)")

case "$LOCATION" in
  .worktrees|worktrees)
    PATH_OUT="$LOCATION/$BRANCH"
    ;;
  ~/.config/superpowers/worktrees/*)
    PATH_OUT="$HOME/.config/superpowers/worktrees/$PROJECT/$BRANCH"
    ;;
  *)
    PATH_OUT="$LOCATION/$BRANCH"
    ;;
esac

echo "{\"status\":\"PATH_READY\",\"worktree_path\":\"$PATH_OUT\",\"project\":\"$PROJECT\"}"
