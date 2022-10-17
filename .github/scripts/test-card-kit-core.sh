#!/bin/bash

set -eo pipefail

xcodebuild -workspace CardKit.xcworkspace \
            -scheme CardKitCore \
            -destination platform=iOS\ Simulator,OS=16.0,name=iPhone\ 13 \
            -destination platform=iOS\ Simulator,OS=16.0,name=iPhone\ 13 \
            clean test | xcpretty
