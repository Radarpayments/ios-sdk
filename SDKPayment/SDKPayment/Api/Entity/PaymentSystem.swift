//
//  PaymentSystem.swift
//  SDKPayment
//
// 
//

import Foundation

public enum PaymentSystem: String, Codable, CaseIterable {
    
    case visa       = "VISA"
    case masterCard = "MASTERCARD"
    case jcb        = "JCB"
    case interac    = "INTERAC"
    case discover   = "DISCOVER"
    case amex       = "AMEX"
    
    init?(rawValueString: String) {
        guard let paymentSystem = PaymentSystem(rawValue: rawValueString) else { return nil }
        
        self = paymentSystem
    }
}
