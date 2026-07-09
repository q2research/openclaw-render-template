#!/bin/sh
set -eu

if [ -x /data/.gbrain/start-autopilot.sh ]; then
  echo "[startup] starting gbrain autopilot"
  HOME=/data GBRAIN_HOME="${GBRAIN_HOME:-/data/gbrain-govdev-company}" bash /data/.gbrain/start-autopilot.sh || echo "[startup] gbrain autopilot did not start"
else
  echo "[startup] gbrain autopilot not installed; continuing"
fi

exec alphaclaw start