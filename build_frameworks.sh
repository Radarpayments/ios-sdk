#!/bin/bash

set -x
set -e

mkdir -p Frameworks/
rm -rf Frameworks/*

./build_xcframework.sh SDKCore
sleep 8
cp -r SDKCore/build/SDKCore.xcframework Frameworks/

./build_xcframework.sh SDKForms
sleep 8
cp -r SDKForms/build/SDKForms.xcframework Frameworks/

./script_build_xcframework.sh ThreeDSSDK "build" "Frameworks"
sleep 8
cp -r sdk_threeds/build/ThreeDSSDK.xcframework Frameworks/

./build_xcframework.sh SDKPayment
sleep 8
cp -r SDKPayment/build/SDKPayment.xcframework Frameworks/



cd Frameworks

mkdir -p output

zip -r "output/SDKCore.zip" "SDKCore.xcframework"
zip -r "output/SDKForms.zip" "SDKForms.xcframework"
zip -r "output/ThreeDSSDK.zip" "ThreeDSSDK.xcframework"
zip -r "output/SDKPayment.zip" "SDKPayment.xcframework"

cd ../