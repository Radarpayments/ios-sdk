//
//  PaymentManager.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms

/// Manager interface for managing the payment process.
protocol PaymentManager {
    
    /// Start the payment process for cards.
    ///
    /// - Parameters:
    ///     - order: order number.
    func checkout(config: CheckoutConfig) throws
    
    /// Stop the payment process.
    func finishWithCheckOrderStatus(exception: SDKException?) throws
}
