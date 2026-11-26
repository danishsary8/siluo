#!/usr/bin/env bash
# Netlify build script: Netlify's build image has no Flutter, so install the
# stable SDK (shallow clone, cached between builds when possible) and build web.
set -euo pipefail

FLUTTER_DIR="${NETLIFY_CACHE_DIR:-$HOME}/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Installing Flutter (stable) into $FLUTTER_DIR"
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --disable-analytics >/dev/null 2>&1 || true
flutter --version
flutter pub get
flutter build web --release --no-web-resources-cdn
