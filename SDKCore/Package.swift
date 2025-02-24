// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SDKCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SDKCore",               
            targets: ["SDKCore"]
        )
    ],
    targets: [
        .target(
            name: "SDKCore",
            path: "SDKCore"
        ),
        .testTarget(
            name: "SDKCoreTests",
            dependencies: ["SDKCore"],
            path: "SDKCoreTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)


