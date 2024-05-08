//
//  CryptogramProcessor.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Interface for the processor which create a cryptogram based on the transferred payment data.
protocol CryptogramProcessor {
    
    ///Creates a cryptogram ready for payment.
    ///
    /// - Parameters:
    ///     - order: payment identifier.
    ///     - timestamp: payment data.
    ///     - uuid: unique identifier.
    ///     - cardInfo: card data for debiting funds.
    ///- Returns: cryptogram for the transferred payment data.
    func create(order: String, 
                timestamp: Int64,
                uuid: String,
                cardInfo: CoreCardInfo,
                registeredFrom: MSDKRegisteredFrom
    ) throws -> String
}
