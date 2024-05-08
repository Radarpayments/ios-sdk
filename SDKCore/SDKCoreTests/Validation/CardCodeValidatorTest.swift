//
//  CardCodeValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class CardCodeValidatorTest: XCTestCase {
    
    var cardCodeValidator: CardCodeValidator!

    override func setUp() {
        super.setUp()

        cardCodeValidator = CardCodeValidator()
    }

    func testShouldAcceptCorrectCode() {
        let result = cardCodeValidator.validate(data: "123")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldNotAcceptEmptyString() {
        let result = cardCodeValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCVC(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptLessThanMinLength() {
        let result = cardCodeValidator.validate(data: "12")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCVC(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

    func testShouldNotAcceptMoreThanMaxLength() {
        let result = cardCodeValidator.validate(data: "1234")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCVC(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

    func testShouldNotAcceptWithLetterSymbols() {
        let result = cardCodeValidator.validate(data: "1AAA")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCVC(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }
}
