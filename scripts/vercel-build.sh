#!/usr/bin/env bash
# Vercel "Build Command" (set in vercel.json). Analyze and tests must pass
# before anything is built, so a broken commit never deploys.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/flutter-env.sh

flutter analyze
flutter test
flutter build web --release --wasm --no-source-maps
