//
//  MerchantInfo.swift
//  SDKPayment
//
// 
//

import Foundation

/// Response DTO for merchant information.
///
/// - Parameters:
///     - merchantUrl the URL of merchant storage.
///     - merchantFullName the name of merchant.
///     - mcc mcc value.
///     - merchantLogin the login of merchant in system.
///     - captchaMode is available captcha.
///     - custom if merchant has a custom rules.
struct MerchantInfo: Codable {
    
    let merchantUrl: String
    let merchantFullName: String
    let mcc: String?
    let merchantLogin: String
    let captchaMode: String
    var custom: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.merchantUrl = try container.decode(String.self, forKey: .merchantUrl)
        self.merchantFullName = try container.decode(String.self, forKey: .merchantFullName)
        self.mcc = try? container.decodeIfPresent(String.self, forKey: .mcc)
        self.merchantLogin = try container.decode(String.self, forKey: .merchantLogin)
        self.captchaMode = try container.decode(String.self, forKey: .captchaMode)
        self.custom = (try? container.decode(Bool.self, forKey: .custom)) ?? false
    }
}
