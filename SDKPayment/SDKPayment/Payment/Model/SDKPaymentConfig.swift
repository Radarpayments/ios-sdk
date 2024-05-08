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
///     - use3DSConfig configuration for 3ds.
///     - keyProviderUrl url for key.
///     - sslContextConfig custom SSL context object with TLS certificates. in the JWS header response
public struct SDKPaymentConfig: Codable {

    let baseURL: String
    let use3DSConfig: Use3DSConfig
    let keyProviderUrl: String
    let applePaySettings: ApplePaySettings?
    
    public init(
        baseURL: String,
        use3DSConfig: Use3DSConfig,
        keyProviderUrl: String,
        applePaySettings: ApplePaySettings? = nil
    ) {
        self.baseURL = baseURL
        self.use3DSConfig = use3DSConfig
        self.keyProviderUrl = keyProviderUrl
        self.applePaySettings = applePaySettings
    }
}
