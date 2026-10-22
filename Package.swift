// swift-tools-version:5.9

// Root manifest for integrators: File → Add Package Dependencies → https://github.com/Radarpayments/ios-sdk
// SDKCore/Package.swift and SDKPayment/Package.swift stay for local development, tests and build_xcframework.sh.

import PackageDescription

let package = Package(
    name: "PayrdrSDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SDKCore",
            targets: ["SDKCore"]
        ),
        .library(
            name: "SDKPayment",
            targets: ["SDKPayment"]
        )
    ],
    targets: [
        .target(
            name: "SDKCore",
            path: "SDKCore/SDKCore"
        ),
        .target(
            name: "SDKPayment",
            dependencies: ["SDKCore"],
            path: "SDKPayment/SDKPayment",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
