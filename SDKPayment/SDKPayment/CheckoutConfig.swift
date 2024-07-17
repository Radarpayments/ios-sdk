//
//  File.swift
//

import Foundation

public struct CheckoutConfig {
    
    let id: PaymentIdType
    
    public init(id: PaymentIdType) {
        self.id = id
    }
}
