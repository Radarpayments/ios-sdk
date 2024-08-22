//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class AddressLine1ValidatorTest: XCTestCase {
    
    var addressLine1Validator: AddressLine1Validator!
    
    override func setUp() {
        super.setUp()
        
        addressLine1Validator = AddressLine1Validator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = addressLine1Validator.validate(data: "Musterstr 17")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = addressLine1Validator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
