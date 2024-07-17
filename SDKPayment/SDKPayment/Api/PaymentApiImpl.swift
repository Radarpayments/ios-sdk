//
//  PaymentApiImpl.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms

final class PaymentApiImpl: NSObject, PaymentApi {

    /// Data class for storing information about 3SD payments.
    ///
    /// - Parameters:
    ///     - threeDSSDK there is 3DS for payment.
    ///     - threeDSServerTransId 3DS2 identifier in 3DS Server .
    ///     - threeDSSDKEncData encrypted device data .
    ///     - threeDSSDKEphemPubKey key for encryption during exchange with ACS.
    ///     - threeDSSDKAppId identifier SDK.
    ///     - threeDSSDKTransId transaction identifier SDK.
    ///     - threeDSSDKReferenceNumber reference number.
    struct PaymentThreeDSInfo {

        let threeDSSDK: Bool
        let threeDSServerTransId: String
        let threeDSSDKEncData: String
        let threeDSSDKEphemPubKey: String
        let threeDSSDKAppId: String
        let threeDSSDKTransId: String
        let threeDSSDKReferenceNumber: String
    }

    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getSessionStatus(mdOrder: String) throws -> SessionStatusResponse {
        let body = ["MDORDER": mdOrder]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/getSessionStatus.do",
            body: body,
            type: SessionStatusResponse.self
        )
    }
    
    func processForm(
        cryptogramApiData: CryptogramApiData,
        threeDSSDK: Bool
    ) throws -> ProcessFormResponse {
        let body = [
            "seToken": cryptogramApiData.paymentToken,
            "MDORDER": cryptogramApiData.mdOrder,
            "TEXT": cryptogramApiData.holder,
            "bindingNotNeeded": "\(!cryptogramApiData.saveCard)",
            "threeDSSDK": "\(threeDSSDK)"
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/processform.do",
            body: body,
            type: ProcessFormResponse.self
        )
    }
    
    func processBindingForm(
        cryptogramApiData: CryptogramApiData,
        threeDSSDK: Bool
    ) throws -> ProcessFormResponse {
        let body = [
            "seToken": cryptogramApiData.paymentToken,
            "MDORDER": cryptogramApiData.mdOrder,
            "TEXT": cryptogramApiData.holder,
            "threeDSSDK": "\(threeDSSDK)"
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/processBindingForm.do",
            body: body,
            type: ProcessFormResponse.self
        )
    }
    
    func processFormSecond(
        cryptogramApiData: CryptogramApiData,
        threeDSParams: PaymentThreeDSInfo
    ) throws -> ProcessFormSecondResponse {
        let body = [
            "seToken": cryptogramApiData.paymentToken,
            "MDORDER": cryptogramApiData.mdOrder,
            "TEXT": cryptogramApiData.holder,
            "bindingNotNeeded": "\(!cryptogramApiData.saveCard)",
            "threeDSSDK": "\(threeDSParams.threeDSSDK)",
            "threeDSServerTransId": threeDSParams.threeDSServerTransId,
            "threeDSSDKEncData": threeDSParams.threeDSSDKEncData,
            "threeDSSDKEphemPubKey": threeDSParams.threeDSSDKEphemPubKey,
            "threeDSSDKAppId": threeDSParams.threeDSSDKAppId,
            "threeDSSDKTransId": threeDSParams.threeDSSDKTransId,
            "threeDSSDKReferenceNumber": threeDSParams.threeDSSDKReferenceNumber
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/processform.do",
            body: body,
            type: ProcessFormSecondResponse.self
        )
    }
    
    func processBindingFormSecond(
        cryptogramApiData: CryptogramApiData,
        threeDSParams: PaymentThreeDSInfo
    ) throws -> ProcessFormSecondResponse {
        let body = [
            "seToken": cryptogramApiData.paymentToken,
            "MDORDER": cryptogramApiData.mdOrder,
            "TEXT": cryptogramApiData.holder,
            "threeDSSDK": "\(threeDSParams.threeDSSDK)",
            "threeDSServerTransId": threeDSParams.threeDSServerTransId,
            "threeDSSDKEncData": threeDSParams.threeDSSDKEncData,
            "threeDSSDKEphemPubKey": threeDSParams.threeDSSDKEphemPubKey,
            "threeDSSDKAppId": threeDSParams.threeDSSDKAppId,
            "threeDSSDKTransId": threeDSParams.threeDSSDKTransId,
            "threeDSSDKReferenceNumber": threeDSParams.threeDSSDKReferenceNumber
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/processBindingForm.do",
            body: body,
            type: ProcessFormSecondResponse.self
        )
    }
    
    func finish3dsVer2PaymentAnonymous(threeDSServerTransId: String) throws {
        let body = ["threeDSServerTransId": threeDSServerTransId]
        
        let response = URLSession.shared.executePostParams(
            urlString: "\(baseUrl)/rest/finish3dsVer2PaymentAnonymous.do",
            paramBody: body
        )
        
        if response.error != nil {
            throw SDKException(cause: response.error)
        }
        
        LogDebug.shared.logIfDebug(message: "\(response)")
    }
    
    func getFinishedPaymentInfo(
        orderId: String
    ) throws -> FinishedPaymentInfoResponse {
        let body = ["orderId": orderId]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/getFinishedPaymentInfo.do",
            body: body,
            type: FinishedPaymentInfoResponse.self
        )
    }
    
    func processApplePay(
        cryptogramApplePayApiData: CryptogramApplePayApiData
    ) throws -> ProcessFormApplePayResponse {
        let jsonBodyDict = [
            "paymentToken": cryptogramApplePayApiData.paymentToken,
            "mdOrder": cryptogramApplePayApiData.mdOrder
        ]
        LogDebug.shared.logIfDebug(message: "\(jsonBodyDict)")
        
        let response = URLSession.shared.executePost(urlString: "\(baseUrl)/applepay/paymentOrder.do", 
                                                     body: jsonBodyDict)
        
        if let data = response.data,
           let processFormResponse = try? JSONDecoder()
            .decode(ProcessFormApplePayResponse.self, from: data) {
            
            return processFormResponse
        }
        
        throw SDKPaymentApiException(message: response.error?.localizedDescription,
                                     cause: response.error)
    }
    
    func unbindCardAnonymous(
        bindingId: String,
        mdOrder: String
    ) throws -> UnbindCardResponse {
        let body = [
            "mdOrder": mdOrder,
            "bindingId": bindingId
        ]
        
        return try startRunCatching(
            urlString: "\(baseUrl)/rest/unbindcardanon.do",
            body: body,
            type: UnbindCardResponse.self
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
        
        LogDebug.shared.logIfDebug(message: "\(response)")
        
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
