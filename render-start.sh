#!/bin/sh
set -eu

GBRAIN_HOME="${GBRAIN_HOME:-/data/gbrain-govdev-company}"
LOCK="$GBRAIN_HOME/.gbrain/autopilot.lock"

# lock contention issue with autopilot, so quick fix for that
if [ -f "$LOCK" ]; then
  PID="$(cat "$LOCK" 2>/dev/null || true)"
  ARGS=""

  if [ -n "$PID" ]; then
    ARGS="$(ps -p "$PID" -o args= 2>/dev/null || true)"
  fi

  case "$ARGS" in
    *"gbrain autopilot"*) ;;
    *)
      echo "[startup] removing dead gbrain autopilot lock pid=${PID:-unknown}"
      rm -f "$LOCK"
      ;;
  esac
fi

if [ -x /data/.gbrain/start-autopilot.sh ]; then
  echo "[startup] starting gbrain autopilot"
  HOME=/data GBRAIN_HOME="$GBRAIN_HOME" bash /data/.gbrain/start-autopilot.sh \
    || echo "[startup] gbrain autopilot did not start"
else
  echo "[startup] gbrain autopilot not installed; continuing"
fi

exec alphaclaw start