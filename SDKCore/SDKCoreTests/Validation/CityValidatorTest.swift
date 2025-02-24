//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class CityValidatorTest: XCTestCase {
    
    var cityValidator: CityValidator!
    
    override func setUp() {
        super.setUp()
        
        cityValidator = CityValidator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = cityValidator.validate(data: "Berlin")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = cityValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
