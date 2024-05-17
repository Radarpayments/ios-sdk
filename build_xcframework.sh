#!/bin/bash

set -x
set -e

# Pass scheme name as the first argument to the script
NAME=$1

cd $NAME
mkdir -p build
rm -rf build
rm -rf DerivedData

# Build the scheme for all platforms that we plan to support
for PLATFORM in "iOS" "iOS Simulator"; do

    case $PLATFORM in
    "iOS")
    RELEASE_FOLDER="Release-iphoneos"
    ;;
    "iOS Simulator")
    RELEASE_FOLDER="Release-iphonesimulator"
    ;;
    esac

    ARCHIVE_PATH=build/$RELEASE_FOLDER

    # Rewrite Package.swift so that it declaras dynamic libraries, since the approach does not work with static libraries
    perl -i -p0e 's/type: .static,//g' Package.swift
    perl -i -p0e 's/type: .dynamic,//g' Package.swift
    perl -i -p0e 's/(library[^,]*,)/$1 type: .dynamic,/g' Package.swift

    xcodebuild -list
    xcodebuild archive -workspace . -scheme $NAME \
            -destination "generic/platform=$PLATFORM" \
            -archivePath $ARCHIVE_PATH \
            -derivedDataPath "build" \
            SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    FRAMEWORK_PATH="$ARCHIVE_PATH.xcarchive/Products/usr/local/lib/$NAME.framework"
    MODULES_PATH="$FRAMEWORK_PATH/Modules"
    mkdir -p $MODULES_PATH

    BUILD_PRODUCTS_PATH="build/Build/Intermediates.noindex/ArchiveIntermediates/$NAME/BuildProductsPath"
    RELEASE_PATH="$BUILD_PRODUCTS_PATH/$RELEASE_FOLDER"
    SWIFT_MODULE_PATH="$RELEASE_PATH/$NAME.swiftmodule"
    RESOURCES_BUNDLE_PATH="$RELEASE_PATH/${NAME}_${NAME}.bundle"

    # Copy Swift modules
    if [ -d $SWIFT_MODULE_PATH ] 
    then
        cp -r $SWIFT_MODULE_PATH $MODULES_PATH
    else
        # In case there are no modules, assume C/ObjC library and create module map
        echo "module $NAME { export * }" > $MODULES_PATH/module.modulemap
        # TODO: Copy headers
    fi

    # Copy resources bundle, if exists 
    if [ -e $RESOURCES_BUNDLE_PATH ] 
    then
        cp -r $RESOURCES_BUNDLE_PATH $FRAMEWORK_PATH
    fi

done

xcodebuild -create-xcframework \
-framework build/Release-iphoneos.xcarchive/Products/usr/local/lib/$NAME.framework \
-framework build/Release-iphonesimulator.xcarchive/Products/usr/local/lib/$NAME.framework \
-output build/$NAME.xcframework


# Rewrite Package.swift without .dynamic
perl -i -p0e 's/type: .dynamic,//g' Package.swift
perl -i -p0e 's/(library[^,]*,)/$1 /g' Package.swift
