#!/bin/bash
# Prints an xcodebuild -destination for the first available iPhone simulator,
# so workflows do not depend on the simulator names of a particular runner image.

set -euo pipefail

UDID=$(xcrun simctl list devices available --json \
    | jq -r '[.devices | to_entries[] | select(.key | contains("iOS")) | .value[] | select(.name | startswith("iPhone"))][0].udid')

if [[ -z "$UDID" || "$UDID" == "null" ]]; then
    echo "No available iPhone simulator" 1>&2
    exit 1
fi

echo "platform=iOS Simulator,id=$UDID"
