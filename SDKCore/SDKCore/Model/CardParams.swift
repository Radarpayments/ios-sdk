//
//  CardParams.swift
//  SDKCore
//
// 
//

import Foundation

/// Card information.
///
///  - Parameters:
///     - pan: card number.
///     - cvc: secret crd code.
///     - expiryMMYY: expiry date for card.
///     - cardHolder: first and last name of cardholder.
///     - mdOrder: order number.
///     - pubKey: public key.
public struct CardParams {
    
    public let mdOrder: String
    public let pan: String
    public let cvc: String
    public let expiryMMYY: String
    public let cardholder: String?
    public let pubKey: String

    public init(
        pan: String,
        cvc: String,
        expiryMMYY: String,
        cardholder: String? = nil,
        mdOrder: String,
        pubKey: String
    ) {
        self.pan = pan
        self.cvc = cvc
        self.expiryMMYY = expiryMMYY
        self.cardholder = cardholder
        self.mdOrder = mdOrder
        self.pubKey = pubKey
    }
}
