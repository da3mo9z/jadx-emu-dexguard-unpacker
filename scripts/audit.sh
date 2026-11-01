#!/usr/bin/env bash
# Read-only CONFOUND AUDIT: what jadx will load + which settings are live. Run before every test.
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/_env.sh"
ROOT="$(cd "$HERE/.." && pwd)"
warn=0; w() { echo "  !! $*"; warn=$((warn+1)); }

echo "== extensions dir: $EXT"
ls -la --time-style=long-iso "$EXT" 2>/dev/null | sed 's/^/  /' || echo "  (missing)"
jars=$(ls "$EXT"/dexguard-unpacker-*.jar 2>/dev/null | wc -l)
[ "$jars" -eq 1 ] || w "expected exactly 1 dexguard-unpacker jar, found $jars"
ls "$EXT"/dexguard-unpacker-native-unidbg*.jar >/dev/null 2>&1 && w "an old unidbg jar is installed; this repo no longer builds one"

echo "== live properties: $PROPS"
if [ -f "$PROPS" ]; then grep -vE '^[[:space:]]*(#|$)' "$PROPS" | sed 's/^/  /'; else echo "  (none - all defaults)"; fi
grep -qE '^nativeBackend=unidbg' "$PROPS" 2>/dev/null && w "nativeBackend=unidbg is ON"
[ -f "$DATA/native-replay.properties" ] && w "native-replay.properties exists - this forces a native bridge ACTIVE"

echo "== checkouts"
co=$(ls -d "$ROOT"/../jadx-emu-dexguard-unpacker*/ 2>/dev/null || true)
echo "$co" | sed 's/^/  /'
[ "$(echo "$co" | grep -c .)" -le 1 ] || w "more than one checkout next to this one - build and deploy from one of them only"

echo
[ "$warn" -eq 0 ] && echo "audit: CLEAN" || echo "audit: $warn warning(s) above"
