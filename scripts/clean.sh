#!/usr/bin/env bash
# Remove this checkout's build output, the installed extension jar, recovered output and jadx's cache.
# Your .properties file is kept. Use baseline.sh for a full reset.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/_env.sh"
ROOT="$(cd "$HERE/.." && pwd)"
( cd "$ROOT" && ./gradlew --stop >/dev/null 2>&1 ) || true
rm -rf "$ROOT/build" "$ROOT/.gradle"
rm -f "$EXT"/dexguard-unpacker*.jar
[ -d "$DATA" ] && find "$DATA" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
rm -rf "$HOME/.cache/jadx"
echo "clean: build output, extension jar, recovered output and jadx cache removed."
echo "In jadx-gui use File > Open on the APK. Don't reload a saved project."
