#!/usr/bin/env bash
# Phase 1: Classifies session context blocks into VERBATIM / SUMMARIZE / EVICT.
# Usage: ./assess_trajectory.sh --project-root /path/to/project

set -euo pipefail

PROJECT_ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root) PROJECT_ROOT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

KNOWLEDGE_DIR="${PROJECT_ROOT}/.gemini/antigravity/knowledge"
AGENTS_MD="${PROJECT_ROOT}/AGENTS.md"

# Emit classification manifest
# In production: agent parses session history and classifies each block.
# This script provides the structural contract the agent must populate.

cat <<EOF
{
  "verbatim_blocks": [
    "active_errors",
    "unresolved_blockers",
    "user_architectural_constraints",
    "agents_md_content"
  ],
  "summarize_blocks": [
    "resolved_tool_call_traces",
    "intermediate_reasoning_scratchpads",
    "approved_implementation_plans"
  ],
  "evict_blocks": [
    "raw_shell_stdout_dumps",
    "raw_compiler_output",
    "directory_listings",
    "redundant_context_repetitions"
  ],
  "token_counts": {
    "verbatim": 0,
    "summarize": 0,
    "evict": 0
  },
  "project_root": "${PROJECT_ROOT}",
  "knowledge_dir": "${KNOWLEDGE_DIR}",
  "agents_md_found": $([ -f "$AGENTS_MD" ] && echo "true" || echo "false"),
  "status": "OK"
}
EOF
