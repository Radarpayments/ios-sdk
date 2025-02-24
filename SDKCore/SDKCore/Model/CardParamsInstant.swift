//
//  File.swift
//  

import Foundation

/// Card information for instant payment.
///
///  - Parameters:
///     - pan: card number.
///     - cvc: secret crd code.
///     - expiryMMYY: expiry date for card.
///     - cardHolder: first and last name of cardholder.
///     - pubKey: public key.
public struct CardParamsInstant {

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
        pubKey: String
    ) {
        self.pan = pan
        self.cvc = cvc
        self.expiryMMYY = expiryMMYY
        self.cardholder = cardholder
        self.pubKey = pubKey
    }
}
