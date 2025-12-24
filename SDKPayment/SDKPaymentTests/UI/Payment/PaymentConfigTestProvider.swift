//
//  PaymentConfigTestProvider.swift
//  SDKPaymentTests
//
// 
//

import Foundation
@testable import SDKPayment

struct PaymentConfigTestProvider {
    
    static func defaultConfig() -> PaymentConfig {
        PaymentConfig(
            order: UUID().uuidString,
            cardSaveOptions: .hide,
            holderInputOptions: .hide,
            cameraScannerOptions: .enabled,
            theme: .system,
            cards: [],
            uuid: UUID().uuidString,
            timestamp: Int64(Date().timeIntervalSince1970),
            locale: .en,
            buttonText: nil,
            storedPaymentMethodCVCRequired: true,
            cardDeleteOptions: .noDelete,
            cardsToDelete: [], 
            editingBindingsIsEnabled: true
        )
    }
}
