//
//  InstancePaymentTest.swift
//  SDKPaymentTests
//
//
//

import XCTest
@testable import SDKPayment
@testable import SDKCore

final class InstancePaymentTest: XCTestCase {

    private let keyProviderUrl = "https://dev.bpcbt.com/payment/se/keys.do"

    func testShouldReturnSuccessPaymentWithoutOrder() throws {
        let environment = ProcessInfo.processInfo.environment
        guard let login = environment["MSDK_TEST_MERCHANT_LOGIN"], !login.isEmpty,
              let password = environment["MSDK_TEST_MERCHANT_PASSWORD"], !password.isEmpty else {
            throw XCTSkip("MSDK_TEST_MERCHANT_LOGIN / MSDK_TEST_MERCHANT_PASSWORD are not set")
        }

        let pubKey = try RemoteKeyProvider(url: keyProviderUrl).provideKey().value
        let tokenResult = SdkCore().generateWithConfig(
            config: SDKCoreConfig(
                paymentMethodParams: .cardParamsInstant(
                    params: CardParamsInstant(
                        pan: "5000001111111115",
                        cvc: "123",
                        expiryMMYY: "12/30",
                        cardholder: "CARD HOLDER",
                        pubKey: pubKey
                    )
                ),
                registeredFrom: .MSDK_PAYMENT
            )
        )
        let seToken = try XCTUnwrap(tokenResult.token, "seToken errors: \(tokenResult.errors)")

        let response = makeInstancePayment(seToken, login: login, password: password)
        XCTAssertEqual("Success", response)
    }

    private func makeInstancePayment(_ seToken: String, login: String, password: String) -> String? {
        let url = "https://dev.bpcbt.com/payment/rest/instantPayment.do"
        let body = [
            "amount": "20000",
            "userName": login,
            "password": password,
            "currency": "643",
            "seToken": seToken,
            "cardHolderName": "CARD HOLDER",
            "backUrl": "https://thebestmerchanturl.com"
        ]

        let (data, _, _) = URLSession.shared.executePostParams(urlString: url, paramBody: body)

        let jsonObject = try? JSONSerialization.jsonObject(with: data ?? Data()) as? [String: Any]
        let orderStatus = jsonObject?["orderStatus"] as? [String: Any]
        let status = orderStatus?["ErrorMessage"] as? String
        return status
    }
}
