//
//  InstancePaymentTest.swift
//  SDKFormsTests
//
// 
//

import XCTest
@testable import SDKForms
@testable import SDKCore

final class InstancePaymentTest: XCTestCase {
    
    var sdkForms: SDKForms!
    
    override func setUp() {
        super.setUp()
        
        sdkForms = SDKForms.initialize(
            sdkConfig: try! SDKConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .build()
        )
    }
    
    func testShouldReturnSuccessPaymentWithoutOrder() {
        let config = PaymentConfigTestProvider.defaultConfig()
        let seToken = try! sdkForms.cryptogramProcessor()
            .create(
                order: "",
                timestamp: config.timestamp,
                uuid: config.uuid,
                cardInfo: CoreCardInfo(
                    identifier: .cardPanIdentifier("5000001111111115"),
                    expDate: "12/30".toExpDate(),
                    cvv: "123"
                ),
                registeredFrom: .MSDK_FORMS
            )
        let response = makeInstancePayment(seToken)
        XCTAssertEqual("Success", response)
    }
    
    private func makeInstancePayment(_ seToken: String) -> String? {
        let url = "https://dev.bpcbt.com/payment/rest/instantPayment.do"
        let body = [
            "amount": "20000",
            "userName": "mobile-sdk-api",
            "password": "vkyvbG0",
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
