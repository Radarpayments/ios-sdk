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
            
            let sdkCoreConfig = SDKCoreConfig(
                paymentMethodParams: .cardParams(
                    params: CardParams(
                        pan: card.pan,
                        cvc: card.cvc,
                        expiryMMYY: card.expiry,
                        cardholder: card.holder,
                        mdOrder: orderId,
                        pubKey: pubKey
                    )
                )
            )
            
            let paymentToken = SdkCore().generateWithConfig(config: sdkCoreConfig).token!
            
            let cryptogramData = TestCryptogramApiData(
                seToken: paymentToken,
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
        clientId: String? = nil,
        email: String? = nil,
        mobilePhone: String? = nil,
        billingPayerData: BillingPayerData? = nil
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
        
        if let email {
            body["email"] = email
        }
        
        if let mobilePhone {
            let mobilePhoneJson = ["mobilePhone": mobilePhone]
            let encodedMobilePhone = try? JSONEncoder().encode(mobilePhoneJson)
            body["orderPayerData"] = String(data: encodedMobilePhone!, encoding: .utf8)!
        }
        
        if let billingPayerData {
            let encodedBillingPayerData = try? JSONEncoder().encode(billingPayerData)
            body["billingPayerData"] = String(data: encodedBillingPayerData!, encoding: .utf8)!
        }
        
        let connection = URLSession.shared.executePostParams(urlString: url, paramBody: body)
        if let data = connection.data, let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let orderId = jsonDict["orderId"] as? String {
            return orderId
        }
        
        throw NSError(domain: "Could not register order", code: 1)
    }
    
    func registerNewSession(
        createSessionbaseUrl: String = "https://dev.bpcbt.com",
        amount: Int = 2000,
        apiKey: String = "9yVrffWNAiHUUVUCQoX4NFHMxmRHYA2yB",
        xVersion: String = "2023-10-31",
        successUrl: String = "sdk://done",
        failureUrl: String = "sdk://done"
    ) -> String {
        var sessionId: String?
        
        let headers = ["Content-Type": "application/json",
                       "X-Version": xVersion,
                       "X-Api-Key": apiKey]
        
        let body: [String: Any] = ["amount": amount,
                                   "currency": "USD",
                                   "successUrl": successUrl,
                                   "failureUrl": failureUrl]
        
        var request = URLRequest(url: NSURL(string: "\(createSessionbaseUrl)/api2/sessions")! as URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data,
                  let responseParams = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return }
            
            sessionId = responseParams["id"] as? String ?? ""
            semaphore.signal()
        }.resume()
        semaphore.wait()
        
        return sessionId ?? ""
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
