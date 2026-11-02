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
    let countryCode: String?
    let summaryItems: [ApplePaySummaryItem]

    public init(
        merchantId: String,
        availablePaymentSystems: [PaymentSystem] = PaymentSystem.allCases,
        countryCode: String? = nil,
        summaryItems: [ApplePaySummaryItem]
    ) {
        self.merchantId = merchantId
        self.availablePaymentSystems = availablePaymentSystems
        self.countryCode = countryCode
        self.summaryItems = summaryItems
    }

    func countryCode(merchantCountryCode: String?) -> String {
        [countryCode, merchantCountryCode]
            .compactMap { $0 }
            .first { $0.count == 2 } ?? "US"
    }
}
