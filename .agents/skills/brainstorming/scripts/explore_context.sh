#!/usr/bin/env bash
# Project Context Explorer — Antigravity Code Mode
# Scans the current repository for docs, recent commits, and structure.
# Returns structured JSON for agent orientation before any design questions.

set -euo pipefail

# Helper for JSON string escaping (replaces jq -Rs .)
json_escape() {
  python -c "import sys, json; print(json.dumps(sys.stdin.read()))"
}

# --- Directory structure (2 levels) ---
TREE=""
if command -v tree &>/dev/null; then
  TREE=$(tree -L 2 --dirsfirst -I "node_modules|.git|dist|build|.next|__pycache__|*.pyc" 2>/dev/null || echo "tree unavailable")
else
  TREE=$(find . -maxdepth 2 -not -path './.git/*' -not -path './node_modules/*' | sort 2>/dev/null || echo "find unavailable")
fi

# --- Recent commits ---
COMMITS=""
if git rev-parse --is-inside-work-tree &>/dev/null; then
  COMMITS=$(git log --oneline -10 2>/dev/null || echo "no git history")
else
  COMMITS="not a git repository"
fi

# --- Existing docs ---
DOCS_LIST=""
if [[ -d "docs" ]]; then
  DOCS_LIST=$(find docs -name "*.md" | head -20 | tr '\n' ',' | sed 's/,$//')
else
  DOCS_LIST="no docs directory found"
fi

# --- README ---
README_SNIPPET=""
if [[ -f "README.md" ]]; then
  README_SNIPPET=$(head -30 README.md | json_escape 2>/dev/null || echo "\"README found but Python encoder failed\"")
else
  README_SNIPPET="\"no README.md found\""
fi

# --- Tech stack detection ---
STACK="unknown"
if [[ -f "package.json" ]]; then
  STACK="node/typescript"
  if grep -q '"react"' package.json 2>/dev/null; then STACK="react/typescript"; fi
elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
  STACK="python"
elif [[ -f "go.mod" ]]; then
  STACK="go"
elif [[ -f "Cargo.toml" ]]; then
  STACK="rust"
fi

# --- Existing spec files ---
SPECS=""
if [[ -d "docs/superpowers/specs" ]]; then
  SPECS=$(ls docs/superpowers/specs/*.md 2>/dev/null | head -10 | tr '\n' ',' | sed 's/,$//' || echo "no specs yet")
else
  SPECS="docs/superpowers/specs not found"
fi

# --- Assemble output ---
if [[ -z "$TREE" && -z "$COMMITS" ]]; then
  echo '{"context_result": "EMPTY", "project_summary": "No project context found. Proceeding with blank-slate design."}'
  exit 0
fi

# Use Python to assemble final JSON for deterministic parsing
python -c "
import sys, json
data = {
    'context_result': 'FOUND',
    'project_summary': {
        'stack': sys.argv[1],
        'directory_tree': sys.argv[2],
        'recent_commits': sys.argv[3],
        'existing_docs': sys.argv[4],
        'existing_specs': sys.argv[5],
        'readme_snippet': json.loads(sys.argv[6])
    }
}
print(json.dumps(data))
" "$STACK" "$TREE" "$COMMITS" "$DOCS_LIST" "$SPECS" "$README_SNIPPET"
