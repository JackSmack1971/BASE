#!/usr/bin/env bash
# zip_skill.sh — Packages a skill directory into a ZIP archive and copies to outputs/
# Usage: ./scripts/zip_skill.sh <skill-name>
# Output: STATUS: PACKAGED <output-path> | STATUS: ERROR <reason>
set -euo pipefail

SKILL_NAME="${1:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo "STATUS: ERROR missing skill-name argument"
  exit 1
fi

SOURCE_DIR=".agents/skills/${SKILL_NAME}"
# Environment-aware output directory (handles Windows/Linux)
OUTPUT_DIR=".agents/outputs"
TMP_ZIP="${SKILL_NAME}.zip"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "STATUS: ERROR source directory not found: ${SOURCE_DIR}"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Remove stale archive if present
rm -f "$TMP_ZIP"

# Create ZIP with skill folder as root
cd "$(dirname "$SOURCE_DIR")"
if command -v zip >/dev/null 2>&1; then
    zip -r "../../${TMP_ZIP}" "$(basename "$SOURCE_DIR")" --quiet
else
    # Fallback for Windows environments (Git Bash) using PowerShell
    powershell.exe -Command "Compress-Archive -Path '$(basename "$SOURCE_DIR")' -DestinationPath '../../${TMP_ZIP}' -Force"
fi
cd - >/dev/null

# Copy to outputs
cp "$TMP_ZIP" "${OUTPUT_DIR}/${SKILL_NAME}.zip"

# Verify output exists and is non-zero size
if [[ ! -s "${OUTPUT_DIR}/${SKILL_NAME}.zip" ]]; then
  echo "STATUS: ERROR output ZIP is empty or missing at ${OUTPUT_DIR}/${SKILL_NAME}.zip"
  exit 1
fi

echo "STATUS: PACKAGED ${OUTPUT_DIR}/${SKILL_NAME}.zip"
exit 0
