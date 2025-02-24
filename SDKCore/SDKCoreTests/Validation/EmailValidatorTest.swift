//
//  File.swift
//  

import XCTest
@testable import SDKCore

final class EmailValidatorTest: XCTestCase {
    
    var emailValidator: EmailValidator!
    
    let correctEmail1 = "email@example.com"
    let correctEmail2 = "firstname.lastname@example.com"
    let correctEmail3 = "email@subdomain.example.com"
    let correctEmail4 = "firstname+lastname@example.com"
    let correctEmail5 = "1234567890@example.com"
    let correctEmail6 = "email@example-one.com"
    let correctEmail7 = "email@example.name"
    let correctEmail8 = "email@example.museum"
    let correctEmail9 = "email@example.co.jp"
    let correctEmail10 = "firstname-lastname@example.com"
    
    let incorrectEmail1 = "plainaddress"
    let incorrectEmail2 = "#@%^%#$@#$@#.com"
    let incorrectEmail3 = "@example.com"
    let incorrectEmail4 = "Joe Smith <email@example.com>"
    let incorrectEmail5 = "email.example.com"
    let incorrectEmail6 = "email@example@example.com"
    let incorrectEmail7 = ".email@example.com"
    let incorrectEmail8 = "email.@example.com"
    let incorrectEmail9 = "email..email@example.com"
    let incorrectEmail10 = "あいうえお@example.com"
    let incorrectEmail11 = "email@example.com (Joe Smith)"
    let incorrectEmail12 = "email@example"
    let incorrectEmail13 = "email@-example.com"
    let incorrectEmail14 = "email@111.222.333.44444"
    let incorrectEmail15 = "email@example..com"
    let incorrectEmail16 = "Abc..123@example.com"
    
    override func setUp() {
        super.setUp()
        
        emailValidator = EmailValidator()
    }
    
    func testShouldAcceptCorrectMail1() {
        let result = emailValidator.validate(data: correctEmail1)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail2() {
        let result = emailValidator.validate(data: correctEmail2)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail3() {
        let result = emailValidator.validate(data: correctEmail3)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail4() {
        let result = emailValidator.validate(data: correctEmail4)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail5() {
        let result = emailValidator.validate(data: correctEmail5)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail6() {
        let result = emailValidator.validate(data: correctEmail6)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail7() {
        let result = emailValidator.validate(data: correctEmail7)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail8() {
        let result = emailValidator.validate(data: correctEmail8)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail9() {
        let result = emailValidator.validate(data: correctEmail9)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldAcceptCorrectMail10() {
        let result = emailValidator.validate(data: correctEmail10)
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorCode)
        XCTAssertNil(result.errorMessage)
    }
    
    func testShouldNotAcceptEmptyValue() {
        let result = emailValidator.validate(data: "")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.required)
        XCTAssertEqual(result.errorMessage, String.requiredField().localized)
    }
    
    func testSholudNotAcceptIncorrectMail1() {
        let result = emailValidator.validate(data: incorrectEmail1)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail2() {
        let result = emailValidator.validate(data: incorrectEmail2)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail3() {
        let result = emailValidator.validate(data: incorrectEmail3)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail4() {
        let result = emailValidator.validate(data: incorrectEmail4)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail5() {
        let result = emailValidator.validate(data: incorrectEmail5)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail6() {
        let result = emailValidator.validate(data: incorrectEmail6)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail7() {
        let result = emailValidator.validate(data: incorrectEmail7)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail8() {
        let result = emailValidator.validate(data: incorrectEmail8)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail9() {
        let result = emailValidator.validate(data: incorrectEmail9)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail10() {
        let result = emailValidator.validate(data: incorrectEmail10)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail11() {
        let result = emailValidator.validate(data: incorrectEmail11)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail12() {
        let result = emailValidator.validate(data: incorrectEmail12)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail13() {
        let result = emailValidator.validate(data: incorrectEmail13)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail14() {
        let result = emailValidator.validate(data: incorrectEmail14)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail15() {
        let result = emailValidator.validate(data: incorrectEmail15)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
    
    func testSholudNotAcceptIncorrectMail16() {
        let result = emailValidator.validate(data: incorrectEmail16)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorCode, ValidationCodes.invalidFormat)
        XCTAssertEqual(result.errorMessage, String.emailIncorrect().localized)
    }
}
