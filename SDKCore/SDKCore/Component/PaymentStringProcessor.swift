//
//  PaymentStringProcessor.swift
//  SDKCore
//
// 
//

import Foundation

/// Forms a line with billing information.
///
/// - Parameters:
///     - order:  order identifier.
///     - timestamp: payment data.
///     - uuid: unique identifier.
///     - cardInfo: card data for withdraw money.
///
/// - Returns: prepared line with payment information.
public protocol PaymentStringProcessor {
    func createPaymentString(
        order: String,
        timestamp: Int64,
        uuid: String,
        cardInfo: CoreCardInfo,
        registeredFrom: MSDKRegisteredFrom
    ) -> String
}
