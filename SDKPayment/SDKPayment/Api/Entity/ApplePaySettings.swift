//
//  ApplePaySettings.swift
//  SDKPayment
//
// 
//

import Foundation

public struct ApplePaySettings: Codable {
    
    let merchantId: String
    let availablePaymentSystems: [PaymentSystem]
    let countryCode: String
    let summaryItems: [ApplePaySummaryItem]

    public init(
        merchantId: String,
        availablePaymentSystems: [PaymentSystem] = PaymentSystem.allCases,
        countryCode: String = "US",
        summaryItems: [ApplePaySummaryItem]
    ) {
        self.merchantId = merchantId
        self.availablePaymentSystems = availablePaymentSystems
        self.countryCode = countryCode
        self.summaryItems = summaryItems
    }
}
