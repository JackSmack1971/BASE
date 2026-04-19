#!/usr/bin/env bash
# Returns today's date in YYYY-MM-DD format for plan filename assembly.
set -euo pipefail

DATE=$(date +%Y-%m-%d)

echo "DATE=${DATE}"
exit 0
