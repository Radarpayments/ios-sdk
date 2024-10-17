//
//  CardBindingIdValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class CardBindingIdValidatorTest: XCTestCase {

    var cardBindongValidator: CardBindingIdValidator!

    override func setUp() {
        super.setUp()

        cardBindongValidator = CardBindingIdValidator()
    }

    func testShouldAcceptCorrectBindingId() {
        let result = cardBindongValidator.validate(data: "513b17f4-e32e-414f-8c74-936fd7027baa")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldNotAcceptEmptyBindingId() {
        let result = cardBindongValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.bindingRequired(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptBlankBindingId() {
        let result = cardBindongValidator.validate(data: "   ")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.bindingRequired(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptWithSpaceBindingId() {
        let result = cardBindongValidator.validate(data: "513b17f4 - e32e-414f-8c74-936fd7027baa")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.bindingIncorrect(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

}
