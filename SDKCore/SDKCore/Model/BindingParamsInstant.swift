//
//  File.swift
//  

import Foundation

/// Information about binding card for instant payment
///
/// - Parameters:
///     - bindingID: number of binding card.
///     - cvc: secret code for card.
///     - pubKey: public key.
public struct BindingParamsInstant {
    
    public let bindingId: String
    public let cvc: String?
    public let pubKey: String
    
    public init(
        pubKey: String,
        bindingId: String,
        cvc: String? = nil
    ) {
        self.pubKey = pubKey
        self.bindingId = bindingId
        self.cvc = cvc
    }
}
