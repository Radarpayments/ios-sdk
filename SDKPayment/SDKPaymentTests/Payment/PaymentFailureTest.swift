//
//  PaymentFailureTest.swift
//  SDKPaymentTests
//

import XCTest
@testable import SDKPayment

final class PaymentFailureTest: XCTestCase {

    private func finishedInfo(_ json: String) throws -> FinishedPaymentInfoResponse {
        try JSONDecoder().decode(FinishedPaymentInfoResponse.self, from: Data(json.utf8))
    }

    func testDeclinedOrderGivesDeclinedExceptionWithGatewayReason() throws {
        let info = try finishedInfo("""
        {"status":"DECLINED","actionCode":116,
         "displayErrorMessage":"Operation declined, please check your details and try again.",
         "errorTypeName":"INSUFFICIENT_FUNDS"}
        """)

        let exception = try XCTUnwrap(info.failureException() as? SDKDeclinedException)

        XCTAssertEqual(exception.message, "Operation declined, please check your details and try again.")
        XCTAssertEqual(exception.actionCode, "116")
        XCTAssertEqual(exception.errorType, "INSUFFICIENT_FUNDS")
    }

    func testCreatedOrderWithActionCodeGivesDeclinedException() throws {
        let info = try finishedInfo("""
        {"status":"CREATED","actionCode":"71015","actionCodeDescription":"Some payment data is invalid",
         "errorTypeName":"DATA_INPUT_ERROR"}
        """)

        let exception = try XCTUnwrap(info.failureException() as? SDKDeclinedException)

        XCTAssertEqual(exception.message, "Some payment data is invalid")
        XCTAssertEqual(exception.actionCode, "71015")
        XCTAssertEqual(exception.errorType, "DATA_INPUT_ERROR")
    }

    func testCreatedOrderWithoutActionCodeGivesTransactionException() throws {
        let info = try finishedInfo(#"{"status":"CREATED"}"#)

        XCTAssertTrue(info.failureException() is SDKTransactionException)
    }

    func testProcessFormErrorTextIsDecoded() throws {
        let response = try JSONDecoder().decode(
            ProcessFormResponse.self,
            from: Data(#"{"errorCode":5,"error":"Invalid payer data: Mobile phone (Invalid value)"}"#.utf8)
        )

        XCTAssertEqual(response.errorCode, 5)
        XCTAssertEqual(response.error, "Invalid payer data: Mobile phone (Invalid value)")
    }
}
