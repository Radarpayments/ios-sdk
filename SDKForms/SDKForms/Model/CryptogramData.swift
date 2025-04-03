//
//  CryptogramData.swift
//  SDKForms
//

import Foundation
import SDKCore

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
        case info
        case deletedCardList
    }

    public let status: PaymentDataStatus
    public let info: PaymentInfo?
    
    public init(
        status: PaymentDataStatus,
        info: PaymentInfo?
    ) {
        self.status = status
        self.info = info
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decode(PaymentDataStatus.self, forKey: .status)
        
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
