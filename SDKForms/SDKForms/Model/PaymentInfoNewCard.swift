//
//  PaymentInfoNewCard.swift
//  SDKForms
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
public struct PaymentInfoNewCard: PaymentInfo {
    
    public var order = ""
    public let saveCard: Bool
    public let holder: String
}
