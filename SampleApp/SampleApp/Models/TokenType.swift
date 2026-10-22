//
//  TokenType.swift
//  MyStore
//

import Foundation

enum TokenType: String, CaseIterable {
    case card = "Card"
    case cardInstant = "Card Instant"
    case binding = "Binding"
    case bindingInstant = "Binding Instant"
    case newPaymentMethod = "New Payment Method"
    case storedPaymentMethod = "Stored Payment Method"
}
