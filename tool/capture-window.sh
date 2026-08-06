#!/bin/bash
#
# Starts a built Flutter Linux app, waits for it to settle and captures the
# screen. Runs inside the Xvfb session started by screenshots.sh, which is the
# only thing that calls it.
#
# usage: capture-window.sh <bundle_dir> <binary> <output.png> <wait_seconds>

set -u
BUNDLE="$1"; BINARY="$2"; OUTPUT="$3"; WAIT="$4"

cd "$BUNDLE" || exit 1

"./$BINARY" >/tmp/flutter-screenshot.log 2>&1 &
PID=$!

sleep "$WAIT"

if ! kill -0 "$PID" 2>/dev/null; then
  echo "    the app exited before it could be captured:" >&2
  tail -5 /tmp/flutter-screenshot.log >&2
  exit 1
fi

import -window root "$OUTPUT"
RC=$?

kill "$PID" 2>/dev/null
wait "$PID" 2>/dev/null

exit $RC
