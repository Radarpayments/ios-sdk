//
//  SDKPaymentConfig.swift
//  SDKPayment
//
//
//

import Foundation

/// SDK Payment configuration options class .
///
/// - Parameters:
///     - baseURL base URL address of the gateway to invoke payment methods.
///     - keyProviderUrl url for key.
///     - sslContextConfig custom SSL context object with TLS certificates. in the JWS header response
public struct SDKPaymentConfig: Codable {

    let baseURL: String
    let keyProviderUrl: String
    let applePaySettings: ApplePaySettings?

    public init(baseURL: String, keyProviderUrl: String, applePaySettings: ApplePaySettings? = nil) {
        self.baseURL = baseURL
        self.keyProviderUrl = keyProviderUrl
        self.applePaySettings = applePaySettings
    }
}
