#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$ROOT_DIR/.local/wewe-rss.pid"

if [[ ! -f "$PID_FILE" ]]; then
  echo "wewe-rss is not running"
  exit 0
fi

PID="$(cat "$PID_FILE")"
if kill -0 "$PID" 2>/dev/null; then
  kill "$PID"
  echo "stopped wewe-rss ($PID)"
else
  echo "stale pid file found for $PID"
fi

rm -f "$PID_FILE"
