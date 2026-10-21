// swift-tools-version:5.9

// Consumer-side check of the root package, used by .github/workflows/ci.yml and release.yml.
// PAYRDR_SDK_URL + PAYRDR_SDK_VERSION (a released tag) or PAYRDR_SDK_REF (a commit) resolve the SDK from git
// like an integrator would; without them the SDK is taken from the repository checkout.

import Foundation
import PackageDescription

let sdk: Package.Dependency
let sdkPackage: String
if let url = Context.environment["PAYRDR_SDK_URL"] {
    if let version = Context.environment["PAYRDR_SDK_VERSION"] {
        sdk = .package(url: url, exact: Version(version)!)
    } else {
        sdk = .package(url: url, revision: Context.environment["PAYRDR_SDK_REF"]!)
    }
    // SwiftPM names a remote package after the last URL component, e.g. "ios-sdk".
    sdkPackage = URL(string: url)!.deletingPathExtension().lastPathComponent
} else {
    let root = URL(fileURLWithPath: Context.packageDirectory).deletingLastPathComponent().deletingLastPathComponent()
    sdk = .package(path: root.path)
    sdkPackage = root.lastPathComponent
}

let package = Package(
    name: "SPMCheck",
    platforms: [.iOS(.v15)],
    dependencies: [sdk],
    targets: [
        .testTarget(
            name: "SPMCheckTests",
            dependencies: [
                .product(name: "SDKCore", package: sdkPackage),
                .product(name: "SDKPayment", package: sdkPackage)
            ]
        )
    ]
)
