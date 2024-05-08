//
//  ApplePaySummaryItem.swift
//  SDKPayment
//
// 
//

import Foundation

public struct ApplePaySummaryItem: Codable {
    
    let label: String
    let amount: Double
    
    public init(label: String, amount: Double) {
        self.label = label
        self.amount = amount
    }
}
