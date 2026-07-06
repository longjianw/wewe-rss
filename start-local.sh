#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$ROOT_DIR/.local"
LOG_FILE="$LOG_DIR/wewe-rss.log"
PID_FILE="$LOG_DIR/wewe-rss.pid"
SERVER_DIR="$ROOT_DIR/apps/server"

mkdir -p "$LOG_DIR" "$SERVER_DIR/data"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "wewe-rss is already running with pid $(cat "$PID_FILE")"
  exit 0
fi

if [[ ! -f "$SERVER_DIR/dist/main.js" ]]; then
  echo "missing build output: $SERVER_DIR/dist/main.js"
  echo "run: pnpm run -r build"
  exit 1
fi

cd "$SERVER_DIR"

python3 - "$SERVER_DIR" "$LOG_FILE" "$PID_FILE" <<'PY'
import os
import subprocess
import sys

server_dir, log_file, pid_file = sys.argv[1:]

with open(log_file, "ab", buffering=0) as log, open(os.devnull, "rb") as devnull:
    proc = subprocess.Popen(
        ["node", "dist/main"],
        cwd=server_dir,
        stdin=devnull,
        stdout=log,
        stderr=log,
        start_new_session=True,
    )

with open(pid_file, "w", encoding="utf-8") as pid_handle:
    pid_handle.write(str(proc.pid))
PY

echo "started wewe-rss with pid $(cat "$PID_FILE")"
echo "log: $LOG_FILE"
