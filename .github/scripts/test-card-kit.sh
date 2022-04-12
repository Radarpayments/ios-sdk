#!/bin/bash

set -eo pipefail

xcodebuild -workspace CardKit.xcworkspace \
            -scheme CardKit \
            -destination platform=iOS\ Simulator,OS=15.0,name=iPhone\ 13 \
            -destination platform=iOS\ Simulator,OS=15.0,name=iPhone\ 13 \
            clean test | xcpretty
