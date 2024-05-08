//
//  ProcessFormApplePayResponse.swift
//  SDKPayment
//
// 
//

import Foundation

struct ProcessFormApplePayResponse: Codable {
    
    let success: Bool
    let data: ApplePayData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.success = (try? container.decodeIfPresent(Bool.self, forKey: .success)) ?? false
        self.data = try? container.decodeIfPresent(ApplePayData.self, forKey: .data)
    }
}
