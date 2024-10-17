//
//  CardHolderValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class CardHolderValidatorTest: XCTestCase {

    var cardHolderValidator: CardHolderValidator!

    override func setUp() {
        super.setUp()

        cardHolderValidator = CardHolderValidator()
    }

    func testShouldAcceptCorrectName() {
        let resultFirst = cardHolderValidator.validate(data: "John Doe")
        
        XCTAssertTrue(resultFirst.isValid)
        XCTAssertNil(resultFirst.errorMessage)
        XCTAssertNil(resultFirst.errorCode)

        let resultSecond = cardHolderValidator.validate(data: "Diana Anika")
        
        XCTAssertTrue(resultSecond.isValid)
        XCTAssertNil(resultSecond.errorMessage)
        XCTAssertNil(resultSecond.errorCode)
    }

    func testShouldNotAcceptIncorrectName() {
        let result = cardHolderValidator.validate(data: "Guðmundur Halima")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCardHolder(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptDigits() {
        let result = cardHolderValidator.validate(data: "665361 165654")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCardHolder(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptMoreThanMaxLength() {
        let result = cardHolderValidator.validate(data: "John DoeEEEEEEEEEEEEEEEEEEEEEEE")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectCardHolder(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }
}
