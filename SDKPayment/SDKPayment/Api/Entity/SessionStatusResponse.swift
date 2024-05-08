//
//  SessionStatusResponse.swift
//  SDKPayment
//
// 
//

import Foundation

/// Response DTO for payment status.
///
/// - Parameters:
///     - redirect url for redirect.
///     - remainingSecs the number of seconds before the order expires.
///     - orderNumber order number.
///     - amount order amount.
///     - bindingItems list of binding card from objects [bindingItems] class.
///     - cvcNotRequired no input required for cvc.
///     - otherWayEnabled other types of payment allowed.
///     - bindingEnabled is it possible to draw a check mark for saving the card.
///     - feeEnabled tax is included.
///     - backUrl url for back redirect.
///     - orderExpired order expired.
///     - is3DSVer2 there is 3DS.
///     - expirationDateCustomValidation is own validation enabled for card expiration.
///     - currencyAlphaCode Country currency code.
///     - merchantInfo information about merchant.
///     - expirationDateCustomValidation is own validation enabled for card expiration.
///     - bindingDeactivationEnabled allows unbinding the card.
///     - merchantOptions list of available payment methods.
struct SessionStatusResponse: Codable {

    let redirect: String?
    let remainingSecs: Int64?
    let orderNumber: String?
    let amount: String?
    var bindingItems = [BindingItem]()
    var cvcNotRequired: Bool = false
    var otherWayEnabled: Bool = false
    var bindingEnabled: Bool = false
    var feeEnabled: Bool = false
    let backUrl: String?
    var orderExpired: Bool = false
    var is3DSVer2: Bool = false
    var expirationDateCustomValidation: Bool = false
    var bindingDeactivationEnabled: Bool = false
    let currencyAlphaCode: String?
    let merchantInfo: MerchantInfo
    var merchantOptions = [MerchantOption]()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.redirect = try? container.decodeIfPresent(String.self, forKey: .redirect)
        self.remainingSecs = try? container.decodeIfPresent(Int64.self, forKey: .remainingSecs)
        self.orderNumber = try? container.decodeIfPresent(String.self, forKey: .orderNumber)
        self.amount = try? container.decodeIfPresent(String.self, forKey: .amount)
        self.bindingItems = (try? container.decode([BindingItem].self, forKey: .bindingItems)) ?? []
        self.cvcNotRequired = (try? container.decode(Bool.self, forKey: .cvcNotRequired)) ?? false
        self.otherWayEnabled = (try? container.decode(Bool.self, forKey: .otherWayEnabled)) ?? false
        self.bindingEnabled = (try? container.decode(Bool.self, forKey: .bindingEnabled)) ?? false
        self.feeEnabled = (try? container.decode(Bool.self, forKey: .feeEnabled)) ?? false
        self.backUrl = try? container.decodeIfPresent(String.self, forKey: .backUrl)
        self.orderExpired = (try? container.decode(Bool.self, forKey: .orderExpired)) ?? false
        self.is3DSVer2 = (try? container.decode(Bool.self, forKey: .is3DSVer2)) ?? false
        self.expirationDateCustomValidation = try container.decode(Bool.self, forKey: .expirationDateCustomValidation)
        self.bindingDeactivationEnabled = (try? container.decode(Bool.self, forKey: .bindingDeactivationEnabled)) ?? false
        self.currencyAlphaCode = try? container.decodeIfPresent(String.self, forKey: .currencyAlphaCode)
        self.merchantInfo = try container.decode(MerchantInfo.self, forKey: .merchantInfo)
        if let options = try? container.decodeIfPresent([String].self, forKey: .merchantOptions) {
            options.forEach { item in
                if let option = MerchantOption(rawValue: item) {
                    self.merchantOptions.append(option)
                }
            }
        }
    }
}
