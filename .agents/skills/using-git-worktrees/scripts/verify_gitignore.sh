#!/usr/bin/env bash
set -euo pipefail

DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) DIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$DIR" ]; then
  echo '{"status":"ERROR","message":"--dir argument required"}'
  exit 1
fi

if git check-ignore -q "$DIR" 2>/dev/null; then
  echo "{\"status\":\"IGNORED\",\"dir\":\"$DIR\"}"
else
  echo "{\"status\":\"NOT_IGNORED\",\"dir\":\"$DIR\"}"
fi
