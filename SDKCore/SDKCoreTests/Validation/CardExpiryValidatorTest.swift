//
//  CardExpiryValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class CardExpiryValidatorTest: XCTestCase {

    var cardExpiryValidator: CardExpiryValidator!

    override func setUp() {
        super.setUp()

        cardExpiryValidator = CardExpiryValidator()
    }

    func testShouldAcceptCorrectCode() {
        let result = cardExpiryValidator.validate(data: "12/29")

        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldAcceptExpiredDate() {
        let validationResult1 = cardExpiryValidator.validate(data: "12/20")
        XCTAssertTrue(validationResult1.isValid)
        XCTAssertNil(validationResult1.errorMessage)
        XCTAssertNil(validationResult1.errorCode)

        let validationResult2 = cardExpiryValidator.validate(data: "12/01")
        XCTAssertTrue(validationResult2.isValid)
        XCTAssertNil(validationResult2.errorMessage)
        XCTAssertNil(validationResult2.errorCode)
    }


    func testShouldAcceptMaxExpiryDate() {
        let result = cardExpiryValidator.validate(data:"12/99")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
        XCTAssertNil(result.errorCode)
    }

    func testShouldNotAcceptLessThanMinLength() {
        let result = cardExpiryValidator.validate(data: "12")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptMoreThanMaxLength() {
        let result = cardExpiryValidator.validate(data: "12/346")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptMoreIncorrectFormat() {
        let result = cardExpiryValidator.validate(data: "12346")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptEmptyValue() {
        let result = cardExpiryValidator.validate(data: "")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptIncorrectMonth() {
        let result = cardExpiryValidator.validate(data: "13/25")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

    func testShouldNotAcceptIncorrectLastYear() {
        let result = cardExpiryValidator.validate(data: "13/19")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectExpiry(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }
}


