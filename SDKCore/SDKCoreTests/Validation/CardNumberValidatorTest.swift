//
//  CardNumberValidatorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class CardNumberValidatorTest: XCTestCase {

    var cardNumberValidator: CardNumberValidator!

    override func setUp() {
        super.setUp()

        cardNumberValidator = CardNumberValidator()
    }

    func testShouldAcceptCorrectNumber() {
        let resultFirst = cardNumberValidator.validate(data: "4556733604106746")
        XCTAssertTrue(resultFirst.isValid)
        XCTAssertNil(resultFirst.errorMessage)
        XCTAssertNil(resultFirst.errorCode)

        let resultSecond = cardNumberValidator.validate(data: "4539985984741055997")
        XCTAssertTrue(resultSecond.isValid)
        XCTAssertNil(resultSecond.errorMessage)
        XCTAssertNil(resultSecond.errorCode)
    }

    func testShouldNotAcceptLessThanMinLength() {
        let result = cardNumberValidator.validate(data: "455673360410674")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectLength(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

    func testShouldNotAcceptEmptyLine() {
        let result = cardNumberValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectNumber(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.required, result.errorCode)
    }

    func testShouldNotAcceptMoreThanMaxLength() {
        let result = cardNumberValidator.validate(data: "45399859847410559971")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectLength(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, result.errorCode)
    }

    func testShouldNotAcceptNotDigits() {
        let result = cardNumberValidator.validate(data: "IncorrectCardNum")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(String.cardIncorrectNumber(), result.errorMessage)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errorCode)
    }

    func testShouldNotAcceptIfLunhFailed() {
        let resultFirst = cardNumberValidator.validate(data: "4532047793306966344")
        XCTAssertFalse(resultFirst.isValid)
        XCTAssertEqual(String.cardIncorrectNumber(), resultFirst.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, resultFirst.errorCode)

        let resultSecond = cardNumberValidator.validate(data: "4556733604106745")
        XCTAssertFalse(resultSecond.isValid)
        XCTAssertEqual(String.cardIncorrectNumber(), resultSecond.errorMessage)
        XCTAssertEqual(ValidationCodes.invalid, resultSecond.errorCode)
    }
}
