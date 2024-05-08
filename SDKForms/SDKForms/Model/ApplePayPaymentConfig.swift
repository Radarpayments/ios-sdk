//
//  ApplePayPaymentConfig.swift
//  SDKForms
//
// 
//

import Foundation
import PassKit

public struct ApplePayPaymentConfig {
    
    public struct SummaryItem {
        let label: String
        let amount: Double
        
        public init(label: String, amount: Double) {
            self.label = label
            self.amount = amount
        }
    }
    
    let merchantId: String
    let currencyCode: String
    let countryCode: String
    var supportedNetworks = [PKPaymentNetwork]()
    let items: [SummaryItem]
    
    public init(
        merchantId: String,
        currencyCode: String,
        countryCode: String,
        supportedNetworks: [PKPaymentNetwork],
        items: [SummaryItem]
    ) {
        self.merchantId = merchantId
        self.currencyCode = currencyCode
        self.countryCode = countryCode
        self.supportedNetworks = supportedNetworks
        self.items = items
    }
}
