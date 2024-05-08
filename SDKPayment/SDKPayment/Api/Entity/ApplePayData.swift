//
//  ApplePayData.swift
//  SDKPayment
//
// 
//

import Foundation

struct ApplePayData: Codable {
    
    let orderId: String
    let is3DSVer2: Bool
    let acsUrl: String?
    let paReq: String?
    let termUrl: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.is3DSVer2 = (try? container.decodeIfPresent(Bool.self, forKey: .is3DSVer2)) ?? false
        self.acsUrl = try? container.decodeIfPresent(String.self, forKey: .acsUrl)
        self.paReq = try? container.decodeIfPresent(String.self, forKey: .paReq)
        self.termUrl = try? container.decodeIfPresent(String.self, forKey: .termUrl)
    }
}
