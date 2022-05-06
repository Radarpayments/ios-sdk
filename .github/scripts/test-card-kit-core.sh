#!/bin/bash

set -eo pipefail

xcodebuild -workspace CardKit.xcworkspace \
            -scheme CardKitCore \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 13 \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 13 \
            clean test | xcpretty
