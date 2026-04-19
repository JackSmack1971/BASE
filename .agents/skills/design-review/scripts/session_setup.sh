#!/usr/bin/env bash
# design-review session setup — returns JSON with all environment variables
# Output contract: JSON object or STATUS: ERROR on fatal failure
set -euo pipefail

SESSION_ID="$$-$(date +%s)"
TEL_START=$(date +%s)

# gstack binary resolution
GSTACK_BIN="${HOME}/.claude/skills/gstack/bin"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$ROOT" ] && [ -d "$ROOT/.claude/skills/gstack/bin" ]; then
  GSTACK_BIN="$ROOT/.claude/skills/gstack/bin"
fi

# Update check (non-fatal)
UPDATE_MSG=$("$GSTACK_BIN/gstack-update-check" 2>/dev/null || true)

# Session tracking
mkdir -p ~/.gstack/sessions
touch ~/.gstack/sessions/"$PPID" 2>/dev/null || true
SESSIONS=$(find ~/.gstack/sessions -mmin -120 -type f 2>/dev/null | wc -l | tr -d ' ')
find ~/.gstack/sessions -mmin +120 -type f -exec rm {} + 2>/dev/null || true

# Config reads
PROACTIVE=$("$GSTACK_BIN/gstack-config" get proactive 2>/dev/null || echo "true")
SKILL_PREFIX=$("$GSTACK_BIN/gstack-config" get skill_prefix 2>/dev/null || echo "false")
CHECKPOINT_MODE=$("$GSTACK_BIN/gstack-config" get checkpoint_mode 2>/dev/null || echo "explicit")
CHECKPOINT_PUSH=$("$GSTACK_BIN/gstack-config" get checkpoint_push 2>/dev/null || echo "false")
TELEMETRY=$("$GSTACK_BIN/gstack-config" get telemetry 2>/dev/null || echo "off")
CROSS_PROJECT=$("$GSTACK_BIN/gstack-config" get cross_project_learnings 2>/dev/null || echo "unset")

# Branch and repo mode
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
eval "$("$GSTACK_BIN/gstack-repo-mode" 2>/dev/null)" 2>/dev/null || true
REPO_MODE="${REPO_MODE:-unknown}"

# Project slug and report dir
eval "$("$GSTACK_BIN/gstack-slug" 2>/dev/null)" 2>/dev/null || true
SLUG="${SLUG:-unknown}"
REPORT_DIR="$HOME/.gstack/projects/$SLUG/designs/design-audit-$(date +%Y%m%d)"
mkdir -p "$REPORT_DIR/screenshots" 2>/dev/null || true

# Learnings
LEARN_FILE="${GSTACK_HOME:-$HOME/.gstack}/projects/$SLUG/learnings.jsonl"
LEARNINGS_COUNT=0
LEARNINGS_DATA="[]"
if [ -f "$LEARN_FILE" ]; then
  LEARNINGS_COUNT=$(wc -l < "$LEARN_FILE" 2>/dev/null | tr -d ' ')
  if [ "$LEARNINGS_COUNT" -gt 5 ] 2>/dev/null; then
    RAW_LEARNINGS=$("$GSTACK_BIN/gstack-learnings-search" --limit 3 2>/dev/null || echo "")
    if [ -n "$RAW_LEARNINGS" ]; then
      LEARNINGS_DATA=$(echo "$RAW_LEARNINGS" | python3 -c "import sys,json; lines=[l.strip() for l in sys.stdin if l.strip()]; print(json.dumps(lines))" 2>/dev/null || echo "[]")
    fi
  fi
fi

# Telemetry analytics write (non-blocking)
if [ "$TELEMETRY" != "off" ]; then
  mkdir -p ~/.gstack/analytics
  echo "{\"skill\":\"design-review\",\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"repo\":\"$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "unknown")\"}" \
    >> ~/.gstack/analytics/skill-usage.jsonl 2>/dev/null || true
fi

# Timeline log (non-blocking background)
"$GSTACK_BIN/gstack-timeline-log" \
  "{\"skill\":\"design-review\",\"event\":\"started\",\"branch\":\"$BRANCH\",\"session\":\"$SESSION_ID\"}" \
  2>/dev/null & disown

# Feature flags
PROACTIVE_PROMPTED=$([ -f ~/.gstack/.proactive-prompted ] && echo "yes" || echo "no")
TEL_PROMPTED=$([ -f ~/.gstack/.telemetry-prompted ] && echo "yes" || echo "no")
LAKE_SEEN=$([ -f ~/.gstack/.completeness-intro-seen ] && echo "yes" || echo "no")
HAS_ROUTING="no"
if [ -f CLAUDE.md ] && grep -q "## Skill routing" CLAUDE.md 2>/dev/null; then
  HAS_ROUTING="yes"
fi
ROUTING_DECLINED=$("$GSTACK_BIN/gstack-config" get routing_declined 2>/dev/null || echo "false")
SPAWNED_SESSION="${OPENCLAW_SESSION:+true}"
SPAWNED_SESSION="${SPAWNED_SESSION:-false}"

# Vendored check
VENDORED="no"
if [ -d ".claude/skills/gstack" ] && [ ! -L ".claude/skills/gstack" ]; then
  if [ -f ".claude/skills/gstack/VERSION" ] || [ -d ".claude/skills/gstack/.git" ]; then
    VENDORED="yes"
  fi
fi

# Emit structured JSON — the agent parses this, never shown raw to user
python3 -c "
import json, sys
print(json.dumps({
  'SESSION_ID': '${SESSION_ID}',
  'TEL_START': ${TEL_START},
  'BRANCH': '${BRANCH}',
  'PROACTIVE': '${PROACTIVE}',
  'SKILL_PREFIX': '${SKILL_PREFIX}',
  'CHECKPOINT_MODE': '${CHECKPOINT_MODE}',
  'CHECKPOINT_PUSH': '${CHECKPOINT_PUSH}',
  'TELEMETRY': '${TELEMETRY}',
  'REPO_MODE': '${REPO_MODE}',
  'SLUG': '${SLUG}',
  'REPORT_DIR': '${REPORT_DIR}',
  'LEARNINGS_COUNT': ${LEARNINGS_COUNT},
  'LEARNINGS': ${LEARNINGS_DATA},
  'PROACTIVE_PROMPTED': '${PROACTIVE_PROMPTED}',
  'TEL_PROMPTED': '${TEL_PROMPTED}',
  'LAKE_SEEN': '${LAKE_SEEN}',
  'HAS_ROUTING': '${HAS_ROUTING}',
  'ROUTING_DECLINED': '${ROUTING_DECLINED}',
  'SPAWNED_SESSION': '${SPAWNED_SESSION}',
  'VENDORED_GSTACK': '${VENDORED}',
  'CROSS_PROJECT': '${CROSS_PROJECT}',
  'UPDATE_MSG': '${UPDATE_MSG}',
  'STATUS': 'OK'
}, indent=2))
" 2>/dev/null || echo '{"STATUS":"ERROR","reason":"python3 not available or gstack binaries missing"}'
