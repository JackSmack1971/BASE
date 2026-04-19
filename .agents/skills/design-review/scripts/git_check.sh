#!/usr/bin/env bash
# Returns structured git working tree status
# Output contract: STATUS: CLEAN | DIRTY with file list
set -euo pipefail

DIRTY_FILES=$(git status --porcelain 2>/dev/null || echo "")

if [ -z "$DIRTY_FILES" ]; then
  echo '{"STATUS": "CLEAN", "files": []}'
else
  FILE_LIST=$(echo "$DIRTY_FILES" | python3 -c "
import sys, json
lines = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(lines))
" 2>/dev/null || echo "[]")
  echo "{\"STATUS\": \"DIRTY\", \"files\": $FILE_LIST, \"count\": $(echo "$DIRTY_FILES" | wc -l | tr -d ' ')}"
fi
