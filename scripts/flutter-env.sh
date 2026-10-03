#!/usr/bin/env bash
# Shared by the Vercel install and build scripts. Resolves the Flutter SDK
# pinned in pubspec.yaml (environment > flutter) and puts it on PATH.

FLUTTER_VERSION="$(sed -n 's/^  flutter: *\([0-9][0-9.]*\) *$/\1/p' pubspec.yaml | head -n 1)"
if [ -z "$FLUTTER_VERSION" ]; then
  echo "Could not read the pinned Flutter version from pubspec.yaml" >&2
  exit 1
fi

# Vercel uses a repo-local SDK; set FLUTTER_DIR to reuse an existing install.
FLUTTER_DIR="${FLUTTER_DIR:-$PWD/.flutter-sdk}"
export PATH="$FLUTTER_DIR/bin:$PATH"
