//
//  File.swift
//  

import XCTest
@testable import SDKCore


final class StateValidatorTest: XCTestCase {
    
    var stateValidator: StateValidator!
    
    override func setUp() {
        super.setUp()
        
        stateValidator = StateValidator()
    }
    
    func testShouldAcceptCorrectValue() {
        let result = stateValidator.validate(data: "DE-BE")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = stateValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
}
