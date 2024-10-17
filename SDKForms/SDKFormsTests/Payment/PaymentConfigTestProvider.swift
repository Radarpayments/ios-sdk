//
//  PaymentConfigTestProvider.swift
//  SDKFormsTests
//
// 
//

import Foundation
@testable import SDKForms

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
            locale: Locale.current,
            buttonText: nil,
            bindingCVCRequired: true,
            cardDeleteOptions: .noDelete,
            cardsToDelete: [], 
            editingBindingsIsEnabled: true
        )
    }
}
