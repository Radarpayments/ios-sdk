//
//  ApplePayData.swift
//  SDKPayment
//
//
//

import Foundation

struct ApplePayData: Codable {

    let orderId: String
    let acsUrl: String?
    let paReq: String?
    let termUrl: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.acsUrl = try? container.decodeIfPresent(String.self, forKey: .acsUrl)
        self.paReq = try? container.decodeIfPresent(String.self, forKey: .paReq)
        self.termUrl = try? container.decodeIfPresent(String.self, forKey: .termUrl)
    }
}
