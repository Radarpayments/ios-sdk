//
//  TestPaymentApiHelper.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import SDKPayment

final class TestPaymentApiHelper {
    
    private let baseUrlString: String
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    func getSessionStatus(mdOrder: String) throws -> TestSessionStatusResponse {
        let body = ["MDORDER": mdOrder]
        
        return try startRunCatching(
            urlString: "\(baseUrlString)/rest/getSessionStatus.do",
            body: body,
            type: TestSessionStatusResponse.self
        )
    }
    
    func processForm(cryptogramApiData: TestCryptogramApiData, threeDSSDK: Bool) throws -> TestProcessFormResponse {
        let body = [
            "seToken": cryptogramApiData.seToken,
            "MDORDER": cryptogramApiData.mdOrder,
            "TEXT": cryptogramApiData.holder,
            "bindingNotNeeded": "\(!cryptogramApiData.saveCard)",
            "threeDSSDK": "\(threeDSSDK)"
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrlString)/rest/processform.do",
            body: body,
            type: TestProcessFormResponse.self
        )
    }
    
    func getFinishedPaymentInfo(orderId: String) throws -> TestFinishedPaymentInfo {
        let body = ["orderId": orderId]
        
        return try startRunCatching(
            urlString: "\(baseUrlString)/rest/getFinishedPaymentInfo.do",
            body: body,
            type: TestFinishedPaymentInfo.self
        )
    }
    
    private func startRunCatching<T: Decodable>(
        urlString: String,
        body: [String: String],
        type: T.Type
    ) throws -> T {
        let response = URLSession.shared.executePostParams(
            urlString: urlString,
            paramBody: body
        )
        
        if let data = response.data,
           let entity = try? JSONDecoder()
            .decode(type, from: data) {
            
            return entity
        }
        
        throw SDKPaymentApiException(
            message: response.error?.localizedDescription,
            cause: response.error
        )
    }
}
