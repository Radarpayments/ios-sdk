//
//  RSACryptogramCipherTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class RSACryptogramCipherTest: XCTestCase {

    var paymentStringProcessor: PaymentStringProcessor!
    var cryptogramCipher: CryptogramCipher!
    var key: Key!
    let pubKey = "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAij/G3JVV3TqYCFZTPmwi4JduQMsZ2HcFLBBA9fYAvApv3FtA+zKdUGgKh/OPbtpsxe1C57gIaRclbzMoafTb0eOdj+jqSEJMlVJYSiZ8Hn6g67evhu9wXh5ZKBQ1RUpqL36LbhYnIrP+TEGR/VyjbC6QTfaktcRfa8zRqJczHFsyWxnlfwKLfqKz5wSqXkShcrwcfRJCyDRjZX6OFUECHsWVK3WMcOV3WZREwbCkh/o5R5Vl6xoyLvSqVEKQiHupJcZu9UEOJiP3yNCn9YPgyFs2vrCeg6qxDPFnCfetcDCLjjLenGF7VyZzBJ9G2NP3k/mNVtD8Kl7lpiurwY7EZwIDAQAB-----END PUBLIC KEY-----"

    override func setUp() {
        super.setUp()
        
        NSTimeZone.default = TimeZone(identifier: "Europe/Moscow")!
        key = Key(value: pubKey, protocol: "RSA", expiration: 1598689996644)
        paymentStringProcessor = DefaultPaymentStringProcessor()
        cryptogramCipher = RSACryptogramCipher()
    }

    func testShouldCreatePaymentCryptogram() {
        let expectedPaymentStringValue = "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077//202012/7f472085-399e-414e-b51c-a7b538aee497//CardHolderName/MSDK_CORE"

        let expectation = expectation(description: "Should create payment cryptogram")

        let paymentString =  paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Tiwamestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .newPaymentMethodIdentifier("4532896701439077"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )

        XCTAssertEqual(paymentString, expectedPaymentStringValue)

        do {
            let cryptogram = try self.cryptogramCipher.encode(data: paymentString, key: self.key)
            print(cryptogram)
        } catch {
            XCTFail("Encryption failed with error: \(error)")
        }

        expectation.fulfill()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }
}
