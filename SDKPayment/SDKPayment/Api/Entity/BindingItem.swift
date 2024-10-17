//
//  BindingItem.swift
//  SDKPayment
//
// 
//

import Foundation

/// DTO for binding card.
///
/// - Parameters:
///     - id identifier for binding card.
///     - label description of card number and expiry date.
///     - paymentSystem payment system for client card.
///     - cardHolder first and last name of cardholder.
///     - createdDate date when card was save at server.
///     - payerEmail cardholder email.
///     - payerPhone cardholder phone.
///     - isMaestro is the card maestro payment system.
public struct BindingItem: Codable {

    let id: String
    let label: String
    let paymentSystem: String
    var cardHolder: String = ""
    let createdDate: Int64
    let payerEmail: String
    let payerPhone: String
    var isMaestro: Bool = false
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.label = try container.decode(String.self, forKey: .label)
        self.paymentSystem = try container.decode(String.self, forKey: .paymentSystem)
        self.cardHolder = (try? container.decodeIfPresent(String.self, forKey: .cardHolder)) ?? ""
        self.createdDate = try container.decode(Int64.self, forKey: .createdDate)
        self.payerEmail = try container.decode(String.self, forKey: .payerEmail)
        self.payerPhone = try container.decode(String.self, forKey: .payerPhone)
        self.isMaestro = (try? container.decode(Bool.self, forKey: .isMaestro)) ?? false
    }
}
