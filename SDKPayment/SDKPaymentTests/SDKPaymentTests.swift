//
//  SDKPaymentTests.swift
//  SDKPaymentTests
//
// 
//

import XCTest
@testable import SDKPayment

class SDKPaymentTests: XCTestCase {

    func testShouldReturnMdOrderFromClearSessionIdString() {
        let correctSessionId = "ps_2GRSj5Du5xYehmv6Pxp48VHDbgnE4zEW6JxrroqVsQGzMtoE1Pvfmj"
        let result = SessionIdUtils().extractValue(from: correctSessionId)
        XCTAssertEqual(result, "d707897c-188c-45ca-8665-487e614e42bb")
    }
    
    func testShouldReturnNilFromSessionIdStringWithoutPrefix() {
        let correctBase58WithoutPrefix = "2GRSj5Du5xYehmv6Pxp48VHDbgnE4zEW6JxrroqVsQGzMtoE1Pvfmj"
        let result = SessionIdUtils().extractValue(from: correctBase58WithoutPrefix)
        XCTAssertNil(result)
    }
    
    func testShouldReturnNilFromIncorrectSessionIdString() {
        let incorrectBase58StringWithPrefix = "ps_GRSj5Du5xYehmv6Pxp48VHDbgnE4zEW6JxrroqVsQGzMtoE1Pvfmj"
        let result = SessionIdUtils().extractValue(from: incorrectBase58StringWithPrefix)
        XCTAssertNil(result)
    }
    
    func testShouldReturnNilFromIncorrectSeesionIdString() {
        let incorrectBase58StringWithoutPrefix = "2GRSj5Du5xYemv6Pxp48VHDbgnE4zEW6JxrroqVsQGzMtoE1Pvfmj"
        let result = SessionIdUtils().extractValue(from: incorrectBase58StringWithoutPrefix)
        XCTAssertNil(result)
    }
}
