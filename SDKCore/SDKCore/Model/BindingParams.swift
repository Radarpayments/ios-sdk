//
//  BindingParams.swift
//  SDKCore
//
// 
//

import Foundation


/// Information about binding card.
///
/// - Parameters:
///     - mdOrder: order number.
///     - bindingID: number of binding card.
///     - cvc: secret code for card.
///     - pubKey: public key.
public struct BindingParams {

    public let mdOrder: String
    public let bindingId: String
    public let cvc: String?
    public let pubKey: String

    public init(
        pubKey: String,
        bindingId: String,
        cvc: String? = nil,
        mdOrder: String = ""
    ) {
        self.pubKey = pubKey
        self.bindingId = bindingId
        self.cvc = cvc
        self.mdOrder = mdOrder
    }
}
