//
//  PaymentInfoBindCard.swift
//  SDKForms
//
// 
//

import Foundation

/// Payment data for the linked card.
///
/// - Parameters:
///     - order: identifier of the paid order.
///     - bindingId: ID of the associated card used for payment.
public struct PaymentInfoBindCard: PaymentInfo {
    
    public var order = ""
    public let bindingId: String
    public var cvc: String?
    public let mandatoryFieldsValues: [String: String]
}
