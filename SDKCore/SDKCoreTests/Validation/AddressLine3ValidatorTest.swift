//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class AddressLine3ValidatorTest: XCTestCase {
    
    var addressLine3Validator: AddressLine3Validator!
    
    override func setUp() {
        super.setUp()
        
        addressLine3Validator = AddressLine3Validator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = addressLine3Validator.validate(data: "Musterstr 17")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = addressLine3Validator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
