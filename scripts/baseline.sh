#!/usr/bin/env bash
# Reset to a known-good state: clean everything, reset the properties to the baseline, then deploy.
# Usage: scripts/baseline.sh [version]
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/_env.sh"
bash "$HERE/clean.sh"
mkdir -p "$DATA"
printf 'telemetry=true\nnativeBackend=none\n' > "$PROPS"
rm -f "$DATA/native-replay.properties"
bash "$HERE/deploy.sh" "${1:-}"
