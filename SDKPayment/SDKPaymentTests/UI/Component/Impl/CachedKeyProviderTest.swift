//
//  CachedKeyProviderTest.swift
//  SDKPaymentTests
//
//
//

import XCTest
@testable import SDKPayment
@testable import SDKCore

final class CachedKeyProviderTest: XCTestCase {

    private struct TestError: Error {}

    private var cachedKeyProvider: CachedKeyProvider!

    private let keyProvider = KeyProviderMock()

    override func setUp() {
        super.setUp()

        UserDefaults.removeKey()
        cachedKeyProvider = CachedKeyProvider(keyProvider: keyProvider)
    }

    func testProvideKeyShouldWrapProviderError() {
        keyProvider.result = .failure(TestError())

        XCTAssertThrowsError(try cachedKeyProvider.provideKey()) { error in
            let exception = error as? KeyProviderException
            XCTAssertEqual(exception?.message, "Error while load active keys")
            XCTAssertTrue(exception?.cause is TestError)
        }
        XCTAssertEqual(keyProvider.provideKeyCallsCount, 1)
    }
}
