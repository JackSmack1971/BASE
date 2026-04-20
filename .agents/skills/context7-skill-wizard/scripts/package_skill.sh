#!/usr/bin/env bash
# package_skill.sh — Creates the skill directory structure and writes SKILL.md + references/
# Usage: ./scripts/package_skill.sh <skill-name>
# Output: STATUS: CREATED <path> | STATUS: ERROR <reason>
set -euo pipefail

SKILL_NAME="${1:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo "STATUS: ERROR missing skill-name argument"
  exit 1
fi

# Validate name charset: lowercase, numbers, hyphens only
if ! echo "$SKILL_NAME" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "STATUS: ERROR skill name '$SKILL_NAME' contains invalid characters (use lowercase-kebab-case)"
  exit 1
fi

TARGET_DIR=".agents/skills/${SKILL_NAME}"

# Create directory structure
mkdir -p "${TARGET_DIR}/references"
mkdir -p "${TARGET_DIR}/scripts"

# Copy validate script into the new skill's scripts/ folder
SCRIPT_SOURCE=".agents/skills/context7-skill-wizard/scripts/validate_generated_skill.py"
if [[ -f "$SCRIPT_SOURCE" ]]; then
  cp "$SCRIPT_SOURCE" "${TARGET_DIR}/scripts/validate_generated_skill.py"
fi

# Verify SKILL.md was written by the agent (agent writes it before calling this script)
if [[ ! -f "${TARGET_DIR}/SKILL.md" ]]; then
  # Create a placeholder so validation can proceed; agent must overwrite with real content
  echo "# PLACEHOLDER — agent must write real SKILL.md content" > "${TARGET_DIR}/SKILL.md"
  echo "STATUS: WARNING SKILL.md not found — created placeholder at ${TARGET_DIR}/SKILL.md"
  exit 0
fi

echo "STATUS: CREATED ${TARGET_DIR}"
exit 0
