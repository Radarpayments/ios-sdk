//
//  StoredPaymentMethodParams.swift
//  SDKCore
//

import Foundation


/// Information about stored payment method.
///
/// - Parameters:
///     - storedPaymentMethodId: id of stored payment method.
///     - cvc: secret code for card.
///     - pubKey: public key.
public struct StoredPaymentMethodParams {

    public let storedPaymentMethodId: String
    public let cvc: String?
    public let pubKey: String

    public init(pubKey: String, storedPaymentMethodId: String, cvc: String? = nil) {
        self.pubKey = pubKey
        self.storedPaymentMethodId = storedPaymentMethodId
        self.cvc = cvc
    }
}
