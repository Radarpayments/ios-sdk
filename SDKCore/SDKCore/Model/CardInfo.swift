//
//  CardInfo.swift
//  SDKCore
//
// 
//

import Foundation

/// Struct for card information used for payment.
///
/// - Parameters:
///     - identifier: card identifier.
///     - expDate: expiration date of the card.
///     - cvv: security code.
public struct CoreCardInfo: Codable {

    public let identifier: CardIdentifier
    public let expDate: ExpiryDate?
    public let cvv: String?
    public let cardHolder: String?

    public init(
        identifier: CardIdentifier,
        expDate: ExpiryDate? = nil,
        cvv: String? = nil,
        cardHolder: String? = nil
    ) {
        self.identifier = identifier
        self.expDate = expDate
        self.cvv = cvv
        self.cardHolder = cardHolder
    }
}
