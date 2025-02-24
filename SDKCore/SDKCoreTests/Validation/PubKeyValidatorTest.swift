//
//  PubKeyValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class PubKeyValidatorTest: XCTestCase {

    var pubKeyValidator: PubKeyValidator!

    private let testPubKey = "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAij/G3JVV3TqYCFZTPmwi4JduQMsZ2HcFLBBA9fYAvApv3FtA+zKdUGgKh/OPbtpsxe1C57gIaRclbzMoafTb0eOdj+jqSEJMlVJYSiZ8Hn6g67evhu9wXh5ZKBQ1RUpqL36LbhYnIrP+TEGR/VyjbC6QTfaktcRfa8zRqJczHFsyWxnlfwKLfqKz5wSqXkShcrwcfRJCyDRjZX6OFUECHsWVK3WMcOV3WZREwbCkh/o5R5Vl6xoyLvSqVEKQiHupJcZu9UEOJiP3yNCn9YPgyFs2vrCeg6qxDPFnCfetcDCLjjLenGF7VyZzBJ9G2NP3k/mNVtD8Kl7lpiurwY7EZwIDAQAB-----END PUBLIC KEY-----"

    override func setUp() {
        super.setUp()

        pubKeyValidator = PubKeyValidator()
    }

    func testShouldAcceptCorrectPubKey() {
        let result = pubKeyValidator.validate(data: testPubKey)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldNotAcceptEmptyPubKey() {
        let result = pubKeyValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.pubKeyRequired().localized, result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptBlankPubKey() {
        let result = pubKeyValidator.validate(data: "        ")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.pubKeyRequired().localized, result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }
}
