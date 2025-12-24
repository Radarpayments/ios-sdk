//
//  PaymentInfoApplePay.swift
//  SDKPayment
//
//
//

import Foundation

/// Apple Pay payment data.
///
/// - Parameters:
///     - order: identifier of the paid order
internal struct PaymentInfoApplePay: PaymentInfo {

    internal let order: String
    internal let paymentToken: String
}
