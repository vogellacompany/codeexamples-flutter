#!/bin/bash
#
# Regenerates the screenshots used as figures in the Flutter book.
#
# Each app carries a tool/screenshot_main.dart entry point that renders one
# screen, selected through the SCREEN compile-time constant. This script builds
# that entry point in release mode, runs it on a virtual X display sized like a
# phone, and captures the window.
#
#   ./tool/screenshots.sh                    # every figure
#   ./tool/screenshots.sh github_viewer      # only one app
#   OUT=/tmp/shots ./tool/screenshots.sh     # write somewhere else
#
# Copy the results into the book with:
#   cp build/screenshots/*.png ../content/020_Scripts_Flutter/img/
#
# Requirements: flutter, xvfb-run, and ImageMagick's import.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/build/screenshots}"
SIZE="${SIZE:-480x900}"
FILTER="${1:-}"

# app | screen | output name | seconds to wait before capturing
#
# The apps that read a live API need the longer wait, the ones that seed their
# own data do not.
FIGURES=(
  "github_viewer|list|github_issues__list|14"
  "github_viewer|detail|github_issues__detail|16"
  "book_catalog|search|book_catalog__search|14"
  "book_catalog|detail|book_catalog__detail|16"
  "fitness_tracker|home|fitness_tracker__home|10"
  "fitness_tracker|form|fitness_tracker__form|9"
  "reminder_app|home|reminder_app__home|10"
  "reminder_app|form|reminder_app__form|9"
)

for tool in flutter xvfb-run import; do
  command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }
done

mkdir -p "$OUT"
failed=0
captured=0


for figure in "${FIGURES[@]}"; do
  IFS='|' read -r app screen name wait <<< "$figure"
  [ -n "$FILTER" ] && [ "$FILTER" != "$app" ] && continue

  echo "==> $app ($screen)"
  if [ ! -f "$ROOT/$app/tool/screenshot_main.dart" ]; then
    echo "    no screenshot entry point, skipping" >&2
    failed=$((failed + 1))
    continue
  fi

  if ! (cd "$ROOT/$app" && flutter build linux --release \
        -t tool/screenshot_main.dart --dart-define=SCREEN="$screen" >/dev/null 2>&1); then
    echo "    build failed" >&2
    failed=$((failed + 1))
    continue
  fi

  # GDK_BACKEND and the unset Wayland variables keep the run on Xvfb. Without
  # them GTK renders on the real compositor and the capture is of your desktop.
  if env -u WAYLAND_DISPLAY -u XDG_SESSION_TYPE GDK_BACKEND=x11 \
      xvfb-run -a -s "-screen 0 ${SIZE}x24" \
      "$ROOT/tool/capture-window.sh" \
        "$ROOT/$app/build/linux/x64/release/bundle" "$app" "$OUT/$name.png" "$wait"; then
    echo "    $OUT/$name.png"
    captured=$((captured + 1))
  else
    echo "    capture failed" >&2
    failed=$((failed + 1))
  fi
done

echo
echo "$captured captured, $failed failed, in $OUT"
[ "$failed" -eq 0 ]
