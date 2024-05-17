//
//  TestOrderHelper.swift
//  SDKPaymentIntegrationUITests
//

//

import XCTest
import Foundation
import SDKPayment
import SDKForms
import SDKCore

final class TestOrderHelper {
    
    let baseUrl: String
    
    private lazy var paymentApi = TestPaymentApiHelper(baseUrlString: baseUrl)
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func preparePayedOrder() throws -> String {
        do {
            let orderId = try registerOrder()
            let card = TestCardHelper.successSSL
            let pubKey = try RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do")
                .provideKey()
                .value
            
            let seToken = SdkCore().generateWithCard(
                params: CardParams(
                    pan: card.pan,
                    cvc: card.cvc,
                    expiryMMYY: card.expiry,
                    cardholder: card.holder,
                    mdOrder: orderId,
                    pubKey: pubKey
                )
            ).token!
            
            let cryptogramData = TestCryptogramApiData(
                seToken: seToken,
                mdOrder: orderId,
                holder: card.holder,
                saveCard: false
            )
            
            _ = try paymentApi.processForm(cryptogramApiData: cryptogramData, threeDSSDK: false)
            let status = try paymentApi.getFinishedPaymentInfo(orderId: orderId).status
            XCTAssertEqual(status, "DEPOSITED")
            
            return orderId
        } catch {
            throw error
        }
    }
    
    func registerOrder(
        amount: Int = 20000,
        returnUrl: String = "sdk://done",
        userName: String = "mobile-sdk-api",
        password: String = "vkyvbG0",
        clientId: String? = nil
    ) throws -> String {
        let url = "https://dev.bpcbt.com/payment/rest/register.do"
        var body = [String: String]()
        body["amount"] = String(amount)
        body["userName"] = userName
        body["password"] = password
        body["returnUrl"] = returnUrl

        if let clientId {
            body["clientId"] = clientId
        }
        
        let connection = URLSession.shared.executePostParams(urlString: url, paramBody: body)
        if let data = connection.data, let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let orderId = jsonDict["orderId"] as? String {
            return orderId
        }
        
        throw NSError(domain: "Could not register order", code: 1)
    }
    
    func encodeConfig(paymentConfig: SDKPaymentConfig) -> String {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        let encodedData = try? encoder.encode(paymentConfig)
        return encodedData?.base64EncodedString() ?? ""
    }
    
    func getSessionStatus(mdOrder: String) throws -> TestSessionStatusResponse {
        return try paymentApi.getSessionStatus(mdOrder: mdOrder)
    }
}
