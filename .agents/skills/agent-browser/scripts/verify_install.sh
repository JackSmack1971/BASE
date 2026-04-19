#!/usr/bin/env bash
# Verifies agent-browser CLI is installed and functional.
# Output: JSON { "status": "ok"|"error", "version": "<ver>", "error_detail": "<msg>" }

set -euo pipefail

if ! command -v agent-browser &> /dev/null; then
  echo '{"status":"error","version":null,"error_detail":"agent-browser not found in PATH. Run: npm i -g agent-browser && agent-browser install"}'
  exit 1
fi

VERSION=$(agent-browser --version 2>&1 || echo "unknown")

if [[ "$VERSION" == "unknown" ]]; then
  echo '{"status":"error","version":null,"error_detail":"agent-browser found but --version failed. Reinstall required."}'
  exit 1
fi

echo "{\"status\":\"ok\",\"version\":\"${VERSION}\",\"error_detail\":null}"
