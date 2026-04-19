#!/usr/bin/env bash
set -euo pipefail

WORKTREE_PATH=""
BRANCH=""
NO_CREATE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)              WORKTREE_PATH="$2"; shift 2 ;;
    --branch)            BRANCH="$2";        shift 2 ;;
    --no-create-branch)  NO_CREATE=true;     shift ;;
    *) shift ;;
  esac
done

if [ -z "$WORKTREE_PATH" ] || [ -z "$BRANCH" ]; then
  echo '{"status":"ERROR","message":"--path and --branch are required"}'
  exit 1
fi

if $NO_CREATE; then
  if git worktree add "$WORKTREE_PATH" "$BRANCH" 2>/dev/null; then
    echo "{\"status\":\"CREATED\",\"path\":\"$WORKTREE_PATH\",\"branch\":\"$BRANCH\"}"
  else
    MSG=$(git worktree add "$WORKTREE_PATH" "$BRANCH" 2>&1 || true)
    echo "{\"status\":\"ERROR\",\"message\":\"$MSG\"}"
  fi
else
  BRANCH_EXISTS=false
  git branch --list "$BRANCH" | grep -q "$BRANCH" && BRANCH_EXISTS=true

  if $BRANCH_EXISTS; then
    echo "{\"status\":\"BRANCH_EXISTS\",\"branch\":\"$BRANCH\"}"
    exit 0
  fi

  if git worktree add "$WORKTREE_PATH" -b "$BRANCH" 2>/dev/null; then
    echo "{\"status\":\"CREATED\",\"path\":\"$WORKTREE_PATH\",\"branch\":\"$BRANCH\"}"
  else
    MSG=$(git worktree add "$WORKTREE_PATH" -b "$BRANCH" 2>&1 || true)
    echo "{\"status\":\"ERROR\",\"message\":\"$MSG\"}"
  fi
fi
