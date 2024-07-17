//
//  OrderNumberValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class OrderNumberValidatorTest: XCTestCase {
    
    var orderNumberValidator: OrderNumberValidator!

    override func setUp() {
        super.setUp()

        orderNumberValidator = OrderNumberValidator()
    }

    func testShouldAcceptCorrectOrderNumber() {
        let result = orderNumberValidator.validate(data: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldNotAcceptEmptyOrderNumber() {
        let result = orderNumberValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.orderIncorrectLength().localized, result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptBlankOrderNumber() {
        let result = orderNumberValidator.validate(data: "    ")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.orderIncorrectLength().localized, result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptWithSpaceOrderNumber() {
        let result = orderNumberValidator.validate(data: "  39ce26e1 -5fd 0-4784-9e6c-25c9f2c2d09e")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.orderIncorrectLength().localized, result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

}
