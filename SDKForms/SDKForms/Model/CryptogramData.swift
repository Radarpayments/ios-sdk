//
//  CryptogramData.swift
//  SDKForms
//
// 
//

import Foundation

/// The result of the formation of a cryptogram.
///
/// - Parameters:
///     - status: state.
///     - seToken: generated cryptogram.
///     - info: payment method information.
///     - deletedCardsList: list of deleted cards.
public struct CryptogramData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case paymentToken
        case info
        case deletedCardList
    }

    public let status: PaymentDataStatus
    public let paymentToken: String
    public let info: PaymentInfo?
    public var deletedCardList = Set<Card>()
    
    public init(
        status: PaymentDataStatus,
        paymentToken: String,
        info: PaymentInfo?,
        deletedCardList: Set<Card>
    ) {
        self.status = status
        self.paymentToken = paymentToken
        self.info = info
        self.deletedCardList = deletedCardList
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decode(PaymentDataStatus.self, forKey: .status)
        paymentToken = try values.decode(String.self, forKey: .paymentToken)
        deletedCardList = try values.decode(Set<Card>.self, forKey: .deletedCardList)
        
        info = if let infoBindCard = try? values.decode(PaymentInfoBindCard.self, forKey: .info) {
            infoBindCard
        } else if let infoNewCard = try? values.decode(PaymentInfoNewCard.self, forKey: .info) {
            infoNewCard
        } else if let infoApplePay = try? values.decode(PaymentInfoApplePay.self, forKey: .info) {
            infoApplePay
        } else { nil }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
     
        try container.encode(status, forKey: .status)
        try container.encode(paymentToken, forKey: .paymentToken)
        try container.encode(deletedCardList, forKey: .deletedCardList)
        
        switch info {
        case let info as PaymentInfoBindCard:
            try container.encode(info, forKey: .info)
        case let info as PaymentInfoNewCard:
            try container.encode(info, forKey: .info)
        case let info as PaymentInfoApplePay:
            try container.encode(info, forKey: .info)
        default:
            break
        }
    }
}
