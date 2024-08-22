//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class PostalCodeValidatorTest: XCTestCase {
    
    var postalCodeValidator: PostalCodeValidator!
    
    override func setUp() {
        super.setUp()
        
        postalCodeValidator = PostalCodeValidator()
    }
    
    func testShouldAcceptCorrectValue1() {
        let result = postalCodeValidator.validate(data: "28374")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }

    func testShouldNotAcceptEmptyValue() {
        let result = postalCodeValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
