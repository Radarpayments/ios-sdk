// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SDKPayment",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SDKPayment",
            targets: ["SDKPayment"]
        )
    ],
    dependencies: [
        .package(name: "SDKCore", path: "../SDKCore"),
        .package(name: "SDKForms", path: "../SDKForms")
    ],
    targets: [
        .target(
            name: "SDKPayment",
            dependencies: [
                .product(name: "SDKCore", package: "SDKCore"),
                .product(name: "SDKForms", package: "SDKForms"),
                .target(name: "ThreeDSSDK")
            ],
            path: "SDKPayment"
        ),
        .binaryTarget(name: "ThreeDSSDK", path: "../Frameworks/ThreeDSSDK.xcframework"),
        .testTarget(
            name: "SDKPaymentTests",
            dependencies: ["SDKPayment"],
            path: "SDKPaymentTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
