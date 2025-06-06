//
//  RequestParams.swift
//  SDKPaymentIntegration
//
//
//

import Foundation

struct RequestParams {
    var userName: String?
    var password: String?
    var amount: String?
    var returnUrl: String?
    var email: String?
    
    var orderId: String?
    var seToken: String?
    var text: String?
    var threeDSSDK: String?
    var threeDSServerTransId: String?
    var threeDSSDKKey: String?
    
    var clientId: String?
}


let requestParamsTest = RequestParams(
    userName: "mobile-sdk-api",
    password: "vkyvbG0",
    amount: "111",
    returnUrl: "sdk://done",
    email: "test@test.com",
    orderId: nil,
    seToken: nil,
    text: "DE DE",
    threeDSSDK: "true",
    threeDSServerTransId: nil,
    threeDSSDKKey: nil,
    clientId: "ClientIdTestIOS"
)
