//
//  Card.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

public struct Card: Codable, Hashable {
    
    public let pan: String
    public let bindingId: String
    public let expiryDate: ExpiryDate?
    
    public init(pan: String, bindingId: String, expiryDate: ExpiryDate? = nil) {
        self.pan = pan
        self.bindingId = bindingId
        self.expiryDate = expiryDate
    }
}
