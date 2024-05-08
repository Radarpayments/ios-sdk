//
//  String+Localized.swift
//  SDKCore
//
// 
//

import Foundation

public extension String {

    var localized: String {
        let path = Bundle.sdkCoreBundle.path(
            forResource: Locale.current.languageCode,
            ofType: "lproj"
        )
        if let bundle = Bundle(path: path ?? "") {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        
        return self
    }
    
    static func cardIncorrectCVC() -> String {
        NSLocalizedString("payrdr_card_incorrect_cvc", comment: "")
    }
    
    static func cardIncorrectLength() -> String {
        NSLocalizedString("payrdr_card_incorrect_length", comment: "")
    }
    
    static func cardIncorrectNumber() -> String {
        NSLocalizedString("payrdr_card_incorrect_number", comment: "")
    }
    
    static func cardIncorrectExpiry() -> String {
        NSLocalizedString("payrdr_card_incorrect_expiry", comment: "")
    }
    
    static func cardIncorrectCardHolder() -> String {
        NSLocalizedString("payrdr_card_incorrect_card_holder", comment: "")
    }
    
    static func orderIncorrectLength() -> String {
        NSLocalizedString("payrdr_order_incorrect_length", comment: "")
    }
    
    static func bindingIncorrectLength() -> String {
        NSLocalizedString("payrdr_binding_incorrect_length", comment: "")
    }
    
    static func pubKeyRequired() -> String {
        NSLocalizedString("payrdr_pub_key_required", comment: "")
    }
    
    static func bindingRequired() -> String {
        NSLocalizedString("payrdr_binding_required", comment: "")
    }
    
    static func bindingIncorrect() -> String {
        NSLocalizedString("payrdr_binding_incorrect", comment: "")
    }
}
