//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class AddressLine2ValidatorTest: XCTestCase {
    
    var addressLine2Validator: AddressLine2Validator!
    
    override func setUp() {
        super.setUp()
        
        addressLine2Validator = AddressLine2Validator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = addressLine2Validator.validate(data: "Musterstr 17")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = addressLine2Validator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
