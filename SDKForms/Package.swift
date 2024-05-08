// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SDKForms",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SDKForms", type: .dynamic,                                   
            targets: ["SDKForms"]
        )
    ],
    dependencies: [
        .package(name: "SDKCore", path: "../SDKCore/")
    ],
    targets: [
        .target(
            name: "SDKForms",
            dependencies: ["SDKCore"],
            path: "SDKForms"
        )
    ],
    swiftLanguageVersions: [.v5]
)
