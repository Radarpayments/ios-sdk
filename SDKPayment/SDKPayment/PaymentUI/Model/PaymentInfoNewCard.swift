//
//  PaymentInfoNewCard.swift
//  SDKPayment
//
//
//

import Foundation

/// Data on payment with a new card.
///
/// - Parameters:
///     - order: identifier of the paid order.
///     - saveCard: user choice - true if he wants to save the card, otherwise false.
///     - holder: is the specified name of the card holder.
internal struct PaymentInfoNewCard: PaymentInfo {

    internal var order = ""
    internal let pan: String
    internal let cvc: String
    internal let expiry: String
    internal let holder: String
    internal let mandatoryFieldsValues: [String: String]
    internal let saveCard: Bool
}
