//
//  PaymentInfoApplePay.swift
//  SDKForms
//
// 
//

import Foundation

/// Apple Pay payment data.
///
/// - Parameters:
///     - order: identifier of the paid order
public struct PaymentInfoApplePay: PaymentInfo {
    
    public let order: String
    public let paymentToken: String
}
