import SDKCore
import SDKPayment
import UIKit
import XCTest

final class SPMCheckTests: XCTestCase {

    func testVersionsMatch() {
        XCTAssertFalse(SdkCore.getSDKVersion().isEmpty)
        XCTAssertEqual(SdkCore.getSDKVersion(), SdkPayment.getSDKVersion())
        if let expected = ProcessInfo.processInfo.environment["EXPECTED_SDK_VERSION"] {
            XCTAssertEqual(SdkPayment.getSDKVersion(), expected)
        }
    }

    func testPaymentResourcesAreBundled() {
        let bundle = Bundle.sdkPaymentBundle
        XCTAssertNotNil(UIImage(named: "add-card", in: bundle, compatibleWith: nil))
        XCTAssertEqual(bundle.localizedString(forKey: "title", value: nil, table: nil), "Enter card details")
    }
}
