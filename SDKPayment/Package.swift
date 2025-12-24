// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SDKPayment",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SDKPayment", type: .dynamic,        
            targets: ["SDKPayment"]
        )
    ],
    dependencies: [
        .package(name: "SDKCore", path: "../SDKCore")
    ],
    targets: [
        .target(
            name: "SDKPayment",
            dependencies: [
                .product(name: "SDKCore", package: "SDKCore")
            ],
            path: "SDKPayment",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SDKPaymentTests",
            dependencies: ["SDKPayment"],
            path: "SDKPaymentTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
