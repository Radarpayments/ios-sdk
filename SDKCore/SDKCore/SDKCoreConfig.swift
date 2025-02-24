//
//  File.swift
//  

import Foundation

/// Configuration for payment token generation
///
/// - Parameters:
///     - paymentMethodParams: params variant for payment method
///     - registeredFrom: the source of tokent generation
///     - timestamp: the timestamp used in the token generation
public struct SDKCoreConfig {
    
    var paymentMethodParams: PaymentParamsVariant
    var registeredFrom: MSDKRegisteredFrom
    var timestamp: Double
    
    public init(
        paymentMethodParams: PaymentParamsVariant,
        registeredFrom: MSDKRegisteredFrom = .MSDK_CORE,
        timestamp: Double = Date().timeIntervalSince1970
    ) {
        self.paymentMethodParams = paymentMethodParams
        self.registeredFrom = registeredFrom
        self.timestamp = timestamp
    }
}
