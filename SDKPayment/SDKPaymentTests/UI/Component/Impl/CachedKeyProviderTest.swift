//
//  CachedKeyProviderTest.swift
//  SDKPaymentTests
//
//
//

import XCTest
import SwiftyMocky
@testable import SDKPayment
@testable import SDKCore

final class CachedKeyProviderTest: XCTestCase {

    private var cachedKeyProvider: CachedKeyProvider!

    private let keyProvider = KeyProviderTestMock()

    private let testDeltaTime: Double = 10_000

    override func setUp() {
        super.setUp()
        
        cachedKeyProvider = CachedKeyProvider(keyProvider: keyProvider)
    }

    func testProvideKeyShouldRequestKey() {}
}


