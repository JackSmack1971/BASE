#!/usr/bin/env bash
# audit_context.sh
# Audits Antigravity context layers and returns structured JSON.
# Usage: ./audit_context.sh [--project-root <path>]
# Output: JSON to stdout

set -euo pipefail

PROJECT_ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root) PROJECT_ROOT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

cd "$PROJECT_ROOT" 2>/dev/null || { echo '{"error":"Cannot access project root","status":"ERROR"}'; exit 1; }

# --- Check file presence ---
gemini_present=false
gemini_lines=0
if [[ -f "GEMINI.md" ]]; then
  gemini_present=true
  gemini_lines=$(wc -l < "GEMINI.md" | tr -d '[:space:]')
fi

agents_present=false
agents_lines=0
if [[ -f "AGENTS.md" ]]; then
  agents_present=true
  agents_lines=$(wc -l < "AGENTS.md" | tr -d '[:space:]')
fi

claude_present=false
if [[ -f "CLAUDE.md" ]]; then
  claude_present=true
fi

rules_populated=false
rules_count=0
if [[ -d ".agents/rules" ]]; then
  rules_count=$(find ".agents/rules" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  [[ "$rules_count" -gt 0 ]] && rules_populated=true
fi

knowledge_present=false
if [[ -d ".gemini/antigravity/knowledge" ]]; then
  knowledge_present=true
fi

skills_populated=false
skills_count=0
if [[ -d ".agents/skills" ]]; then
  skills_count=$(find ".agents/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')
  [[ "$skills_count" -gt 0 ]] && skills_populated=true
fi

# --- Bloat warnings ---
bloat_warnings='[]'
tmp_bloat=()
[[ "$gemini_lines" -gt 150 ]] && tmp_bloat+=("\"GEMINI.md exceeds 150 lines (${gemini_lines}): decompose into Skills/KIs\"")
[[ "$agents_lines" -gt 150 ]] && tmp_bloat+=("\"AGENTS.md exceeds 150 lines (${agents_lines}): trim to tech-stack baseline\"")
if [[ "${#tmp_bloat[@]}" -gt 0 ]]; then
  bloat_warnings="[$(IFS=,; echo "${tmp_bloat[*]}")]"
fi

# --- Missing layers ---
missing='[]'
tmp_missing=()
[[ "$gemini_present" == "false" ]] && tmp_missing+=("\"GEMINI.md missing (CRITICAL: no workspace rules)\"")
[[ "$agents_present" == "false" ]] && tmp_missing+=("\"AGENTS.md missing (WARNING: no cross-tool baseline)\"")
[[ "$rules_populated" == "false" ]] && tmp_missing+=("\"No .agents/rules/ files (WARNING: no passive constraints)\"")
[[ "$knowledge_present" == "false" ]] && tmp_missing+=("\"No .gemini/antigravity/knowledge/ (WARNING: no KI persistence)\"")
if [[ "${#tmp_missing[@]}" -gt 0 ]]; then
  missing="[$(IFS=,; echo "${tmp_missing[*]}")]"
fi

# --- Overall status ---
status="CONTEXT_HEALTHY"
if [[ "$gemini_present" == "false" ]]; then
  status="CONTEXT_CRITICAL"
elif [[ "${#tmp_missing[@]}" -gt 0 || "${#tmp_bloat[@]}" -gt 0 ]]; then
  status="CONTEXT_WARNINGS"
fi

cat <<EOF
{
  "gemini_md_present": $gemini_present,
  "gemini_md_line_count": $gemini_lines,
  "agents_md_present": $agents_present,
  "agents_md_line_count": $agents_lines,
  "claude_md_present": $claude_present,
  "rules_dir_populated": $rules_populated,
  "rules_file_count": $rules_count,
  "knowledge_dir_present": $knowledge_present,
  "skills_dir_populated": $skills_populated,
  "skills_count": $skills_count,
  "bloat_warnings": $bloat_warnings,
  "missing_layers": $missing,
  "status": "$status"
}
EOF
