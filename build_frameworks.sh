#!/bin/bash

set -x
set -e

./build_clean.sh
mkdir -p Frameworks/

./build_xcframework.sh SDKCore
sleep 8
cp -r SDKCore/build/SDKCore.xcframework Frameworks/

./build_xcframework.sh SDKPayment
sleep 8
cp -r SDKPayment/build/SDKPayment.xcframework Frameworks/

cd Frameworks

mkdir -p output

zip -r "output/SDKCore.zip" "SDKCore.xcframework"
zip -r "output/SDKPayment.zip" "SDKPayment.xcframework"

cd ../
