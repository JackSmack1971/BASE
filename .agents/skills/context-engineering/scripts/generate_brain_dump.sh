#!/usr/bin/env bash
# generate_brain_dump.sh
# Generates a structured brain-dump artifact for session initialization.
# Usage: ./generate_brain_dump.sh [--project-root <path>] [--stack <csv>]
# Output: JSON artifact to stdout

set -euo pipefail

PROJECT_ROOT="."
STACK="unknown"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root) PROJECT_ROOT="$2"; shift 2 ;;
    --stack)        STACK="$2"; shift 2 ;;
    *) shift ;;
  esac
done

cd "$PROJECT_ROOT" 2>/dev/null || { echo '{"error":"Cannot access project root","status":"ERROR"}'; exit 1; }

PROJECT_NAME=$(basename "$(pwd)")

# --- Gather tech stack from package.json / pyproject.toml if not provided ---
if [[ "$STACK" == "unknown" ]]; then
  if [[ -f "package.json" ]]; then
    deps=$(python3 -c "
import json, sys
try:
  d = json.load(open('package.json'))
  keys = list(d.get('dependencies',{}).keys()) + list(d.get('devDependencies',{}).keys())
  print(','.join(keys[:10]))
except: print('unknown')
" 2>/dev/null || echo "unknown")
    STACK="node:$deps"
  elif [[ -f "pyproject.toml" ]]; then
    STACK="python:pyproject"
  elif [[ -f "go.mod" ]]; then
    STACK="go:$(head -1 go.mod | awk '{print $2}')"
  fi
fi

# --- Gather directory structure (top 2 levels) ---
dir_structure=$(find . -maxdepth 2 -not -path './.git/*' -not -path './node_modules/*' \
  -not -path './.agents/*' -not -path './.gemini/*' 2>/dev/null \
  | head -40 | sed 's|^\./||' | tr '\n' ',' | sed 's/,$//')

# --- Gather commands from GEMINI.md or package.json scripts ---
commands="run npm scripts"
if [[ -f "package.json" ]]; then
  commands=$(python3 -c "
import json
try:
  s = json.load(open('package.json')).get('scripts',{})
  print(', '.join([f'{k}: npm run {k}' for k in list(s.keys())[:6]]))
except: print('see package.json')
" 2>/dev/null || echo "see package.json")
fi

# --- Check for existing rules ---
rules_summary="none"
if [[ -f "GEMINI.md" ]]; then
  rules_summary="GEMINI.md present ($(wc -l < GEMINI.md | tr -d '[:space:]') lines)"
elif [[ -f "AGENTS.md" ]]; then
  rules_summary="AGENTS.md present ($(wc -l < AGENTS.md | tr -d '[:space:]') lines)"
elif [[ -f "CLAUDE.md" ]]; then
  rules_summary="CLAUDE.md present — migrate to GEMINI.md for Antigravity"
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%SZ")

cat <<EOF
{
  "project_name": "$PROJECT_NAME",
  "project_root": "$(pwd | sed 's/^\([A-Z]\):/\/\L\1/')",
  "stack_detected": "$STACK",
  "commands": "$commands",
  "directory_structure_sample": "$dir_structure",
  "rules_layer_status": "$rules_summary",
  "generated_at": "$TIMESTAMP",
  "brain_dump_template": {
    "project_context": "We are building $PROJECT_NAME using $STACK",
    "relevant_spec": "[Load only the section relevant to current task]",
    "key_constraints": "[Extract from GEMINI.md Boundaries section]",
    "files_involved": "[List after reading source files for current task]",
    "related_patterns": "[Pointer to one example file in codebase]",
    "known_gotchas": "[Extract from GEMINI.md or prior KI artifacts]"
  },
  "knowledge_item_path": ".gemini/antigravity/knowledge/Project-$PROJECT_NAME/project_history.md",
  "status": "BRAIN_DUMP_GENERATED"
}
EOF
