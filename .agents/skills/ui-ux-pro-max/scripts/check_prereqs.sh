#!/usr/bin/env bash
# check_prereqs.sh — Prerequisite verification for ui-ux-pro-max skill
# Output format: JSON for deterministic agent parsing

set -euo pipefail

PYTHON_CMD=""
PYTHON_VERSION=""
STATUS="OK"
MISSING=""
INSTALL_CMD=""

# Detect Python
if command -v python3 &>/dev/null; then
  PYTHON_CMD="python3"
  PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
elif command -v python &>/dev/null; then
  PY_VER=$(python --version 2>&1 | awk '{print $2}')
  MAJOR=$(echo "$PY_VER" | cut -d. -f1)
  if [ "$MAJOR" -ge 3 ]; then
    PYTHON_CMD="python"
    PYTHON_VERSION="$PY_VER"
  fi
fi

if [ -z "$PYTHON_CMD" ]; then
  STATUS="ERROR"
  MISSING="python3"
  # Detect OS for install guidance
  if [[ "$OSTYPE" == "darwin"* ]]; then
    INSTALL_CMD="brew install python3"
  elif [[ -f /etc/debian_version ]]; then
    INSTALL_CMD="sudo apt update && sudo apt install python3"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    INSTALL_CMD="winget install Python.Python.3.12"
  else
    INSTALL_CMD="Install Python 3.x from https://python.org"
  fi
fi

# Check search.py exists
SCRIPT_PATH=".agents/skills/ui-ux-pro-max/scripts/search.py"
SCRIPT_EXISTS="false"
if [ -f "$SCRIPT_PATH" ]; then
  SCRIPT_EXISTS="true"
else
  if [ "$STATUS" == "OK" ]; then
    STATUS="ERROR"
    MISSING="search.py not found at $SCRIPT_PATH"
    INSTALL_CMD="Ensure ui-ux-pro-max skill package is fully installed with scripts/ directory."
  fi
fi

# Output JSON
cat <<EOF
{
  "STATUS": "$STATUS",
  "PYTHON_CMD": "$PYTHON_CMD",
  "PYTHON_VERSION": "$PYTHON_VERSION",
  "SCRIPT_EXISTS": $SCRIPT_EXISTS,
  "SCRIPT_PATH": "$SCRIPT_PATH",
  "MISSING": "$MISSING",
  "INSTALL_CMD": "$INSTALL_CMD"
}
EOF
