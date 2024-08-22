//
//  String+Extensions.swift
//  SDKForms
//
// 
//

import Foundation

public extension String {
    
    var localized: String {
        let path = Bundle.sdkFormsBundle.path(
            forResource: LocalizationSetting.shared.getLanguage()?.rawValue ?? "en",
            ofType: "lproj"
        )
        if let bundle = Bundle(path: path ?? "") {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        
        return self
    }
    
    static func cardDetailsTitle() -> String {
        NSLocalizedString("title", comment: "").localized
    }
    
    static func cardTitle() -> String {
        NSLocalizedString("card", comment: "").localized
    }
    
    static func cardHolder() -> String {
        NSLocalizedString("cardholder", comment: "").localized
    }
    
    static func cardholderPlaceholder() -> String {
        NSLocalizedString("cardholderPlaceholder", comment: "").localized
    }
    
    static func cardNumberTitle() -> String {
        NSLocalizedString("cardNumber", comment: "").localized
    }
    
    static func mmYY() -> String {
        NSLocalizedString("MM/YY", comment: "").localized
    }
    
    static func cvcTitle() -> String {
        NSLocalizedString("CVC", comment: "").localized
    }
    
    static func doneButtonTitle() -> String {
        NSLocalizedString("doneButton", comment: "").localized
    }
    
    static func scanBackButtonTitle() -> String {
        NSLocalizedString("scanBackButton", comment:  "").localized
    }
    
    static func expiryTitle() -> String {
        NSLocalizedString("expiry", comment: "").localized
    }
    
    static func cvcDescription() -> String {
        NSLocalizedString("cvcDescription", comment: "").localized
    }
    
    static func incorrectLength() -> String {
        NSLocalizedString("incorrectLength", comment: "").localized
    }
    
    static func incorrectCardNumber() -> String {
        NSLocalizedString("incorrectCardNumber", comment: "").localized
    }
    
    static func incorrectExpiry() -> String {
        NSLocalizedString("incorrectExpiry", comment: "").localized
    }
    
    static func incorrectCvc() -> String {
        NSLocalizedString("incorrectCvc", comment: "").localized
    }
    
    static func incorrectCardholder() -> String {
        NSLocalizedString("incorrectCardholder", comment: "").localized
    }
    
    static func switchViewTitle() -> String {
        NSLocalizedString("switchViewTitle", comment: "").localized
    }
    
    static func newCard() -> String {
        NSLocalizedString("newCard", comment: "").localized
    }
    
    static func editTitle() -> String {
        NSLocalizedString("edit", comment: "").localized
    }
    
    static func saveTitle() -> String {
        NSLocalizedString("save", comment: "").localized
    }
    
    static func payByCard() -> String {
        NSLocalizedString("payByCard", comment: "").localized
    }
    
    static func addCard() -> String {
        NSLocalizedString("addCard", comment: "").localized
    }
    
    static func allPaymentMethods() -> String {
        NSLocalizedString("allPaymentMethods", comment: "").localized
    }
    
    static func payment() -> String {
        NSLocalizedString("payment", comment: "").localized
    }
    
    static  func cardNumber() -> String {
        NSLocalizedString("cardNumber", comment: "").localized
    }
    
    static func pay() -> String {
        NSLocalizedString("pay", comment: "").localized
    }
    
    static func allCards() -> String {
        NSLocalizedString("allCards", comment: "").localized
    }
    
    static  func removeBindingAlertTitle() -> String {
        NSLocalizedString("removeBindingAlertTitle", comment: "").localized
    }
    
    static func removeBindingAlertDescription() -> String {
        NSLocalizedString("removeBindingAlertDescription", comment: "").localized
    }
    
    static func cancelTitle() -> String {
        NSLocalizedString("cancel", comment: "").localized
    }
    
    static func removeTitle() -> String {
        NSLocalizedString("remove", comment: "").localized
    }
    
    static func paymentMethod() -> String {
        NSLocalizedString("paymentMethod", comment: "").localized
    }
    
    static func email() -> String {
        NSLocalizedString("email", comment: "").localized
    }
    
    static func phoneNumber() -> String {
        NSLocalizedString("phoneNumber", comment: "").localized
    }
    
    static func country() -> String {
        NSLocalizedString("country", comment: "").localized
    }
    
    static func state() -> String {
        NSLocalizedString("state", comment: "").localized
    }
    
    static func city() -> String {
        NSLocalizedString("city", comment: "").localized
    }
    
    static func postalCode() -> String {
        NSLocalizedString("postalCode", comment: "").localized
    }
    
    static func addressLine1() -> String {
        NSLocalizedString("addressLine1", comment: "").localized
    }
    
    static func addressLine2() -> String {
        NSLocalizedString("addressLine2", comment: "").localized
    }
    
    static func addressLine3() -> String {
        NSLocalizedString("addressLine3", comment: "").localized
    }
}
