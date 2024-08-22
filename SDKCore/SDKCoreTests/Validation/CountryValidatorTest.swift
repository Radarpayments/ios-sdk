//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class CountryValidatorTest: XCTestCase {
    
    var countryValidator: CountryValidator!
    
    override func setUp() {
        super.setUp()
        
        countryValidator = CountryValidator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = countryValidator.validate(data: "Germany")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = countryValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
