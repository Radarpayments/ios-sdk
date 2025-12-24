//
//  ApplePayPaymentConfig.swift
//  SDKPayment
//
//
//

import Foundation
import PassKit

internal struct ApplePayPaymentConfig {

    internal struct SummaryItem {
        let label: String
        let amount: Double

        internal init(label: String, amount: Double) {
            self.label = label
            self.amount = amount
        }
    }

    let merchantId: String
    let currencyCode: String
    let countryCode: String
    var supportedNetworks = [PKPaymentNetwork]()
    let items: [SummaryItem]

    internal init(
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
