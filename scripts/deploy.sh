#!/usr/bin/env bash
# Build the extension and install it as the only dexguard-unpacker jar, then run the audit.
# Usage: scripts/deploy.sh [version]   (the version defaults to the one in build.gradle.kts)
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/_env.sh"
ROOT="$(cd "$HERE/.." && pwd)"
if [ -n "${1:-}" ]; then export VERSION="$1"; fi
mkdir -p "$EXT"
( cd "$ROOT" && ./gradlew clean test jar )
JAR="$(ls -t "$ROOT"/build/libs/dexguard-unpacker-*.jar | head -n 1)"
rm -f "$EXT"/dexguard-unpacker*.jar
cp -f "$JAR" "$EXT/"
echo; bash "$HERE/audit.sh"
echo; echo "Restart jadx. The log should show: dexguard-unpacker v... | nativeBackend=none ..."
