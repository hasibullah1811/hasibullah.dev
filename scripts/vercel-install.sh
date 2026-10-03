#!/usr/bin/env bash
# Vercel "Install Command" (set in vercel.json). Installs the pinned Flutter
# SDK and fetches packages.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/flutter-env.sh

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Installing Flutter $FLUTTER_VERSION into $FLUTTER_DIR"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

flutter config --no-analytics --no-cli-animations > /dev/null
installed="$(flutter --version --machine | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')"
if [ "$installed" != "$FLUTTER_VERSION" ]; then
  echo "Flutter $installed found, but pubspec.yaml pins $FLUTTER_VERSION" >&2
  exit 1
fi

flutter pub get
