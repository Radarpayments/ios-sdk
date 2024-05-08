//
//  StringExtensionsTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class StringExtensionsTest: XCTestCase {
    
    func testToExpDateShouldReturnCorrectValue() {
        XCTAssertEqual(ExpiryDate(expYear: 2000, expMonth: 1), try "01/00".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2001, expMonth: 1), try "01/01".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2009, expMonth: 2), try "02/09".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2009, expMonth: 3), try "03/09".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2009, expMonth: 4), try "04/09".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2009, expMonth: 5), try "05/09".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2009, expMonth: 6), try "06/09".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2019, expMonth: 7), try "07/19".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2020, expMonth: 8), try "08/20".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2021, expMonth: 9), try "09/21".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2022, expMonth: 10), try "10/22".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2022, expMonth: 11), try "11/22".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2022, expMonth: 12), try "12/22".toExpDate())
        XCTAssertEqual(ExpiryDate(expYear: 2099, expMonth: 12), try "12/99".toExpDate())
    }
    
    func testToExpDateShouldThrowExceptionForEmptyString() {
        XCTAssertThrowsError(try "".toExpDate(), "Error Domain=Incorrect format, should be MM/YY. Code=-1 (null)")
    }
    
    func testToExpDateShouldThrowExceptionForNotDigitsSymbols() {
        XCTAssertThrowsError(try "abcd".toExpDate(), "Error Domain=Invalid month or year. Code=-1 (null)")
    }
    
    func testToExpDateShouldThrowExceptionForLongString() {
        XCTAssertThrowsError(try "01/2004".toExpDate(), "Error Domain=Incorrect format, should be MM/YY. Code=-1 (null)")
    }
    
    func testPemKeyContentShouldRemoveSpacesHeaderAndFooter() {
        let pem = """
        -----BEGIN PUBLIC KEY-----
        Content
        -----END PUBLIC KEY-----
        """

        let content = pem.pemKeyContent()
        XCTAssertEqual(content, "Content")
    }
}
