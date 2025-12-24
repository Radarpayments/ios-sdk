//
//  PaymentInfoBindCard.swift
//  SDKPayment
//
//
//

import Foundation

/// Payment data for the linked card.
///
/// - Parameters:
///     - order: identifier of the paid order.
///     - bindingId: ID of the associated card used for payment.
internal struct PaymentInfoBindCard: PaymentInfo {

    internal var order = ""
    internal let bindingId: String
    internal var cvc: String?
    internal let mandatoryFieldsValues: [String: String]
}
