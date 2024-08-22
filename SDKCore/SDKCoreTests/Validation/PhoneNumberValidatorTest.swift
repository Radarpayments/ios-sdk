//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class PhoneNumberValidatorTest: XCTestCase {
    
    var phoneNumberValidator: PhoneNumberValidator!
    
    override func setUp() {
        super.setUp()
        
        phoneNumberValidator = PhoneNumberValidator()
    }
    
    func testShouldAcceptCorrectPhoneNumber1() {
        let result = phoneNumberValidator.validate(data: "+35799902871")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectPhoneNumber2() {
        let result = phoneNumberValidator.validate(data: "35799902871")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = phoneNumberValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
    
    func testShouldNotAcceptIncorrectPhoneNumber2() {
        let result = phoneNumberValidator.validate(data: "+357 999 028 71")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.phoneNumberIncorrect().localized)
    }
    
    func testShouldNotAcceptIncorrectPhoneNumber3() {
        let result = phoneNumberValidator.validate(data: "++35799902871")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.phoneNumberIncorrect().localized)
    }
    
    func testShouldNotAcceptIncorrectPhoneNumber4() {
        let result = phoneNumberValidator.validate(data: "+357-99902871")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.phoneNumberIncorrect().localized)
    }
    
    func testShouldNotAcceptIncorrectPhoneNumber5() {
        let result = phoneNumberValidator.validate(data: "#35799902871")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.phoneNumberIncorrect().localized)
    }
    
    func testShouldNotAcceptIncorrectPhoneNumber6() {
        let result = phoneNumberValidator.validate(data: "*35799902871")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.phoneNumberIncorrect().localized)
    }
}
