//
//  String+Extensions.swift
//  SDKPayment
//
//
//

import Foundation

extension String {

    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }

    public var localized: String {
        let path = Bundle.sdkFormsBundle.path(
            forResource: LocalizationSetting.shared.getLanguage()?.rawValue ?? "en",
            ofType: "lproj"
        )

        if let bundle = Bundle(path: path ?? "") {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }

        return self
    }

    public func containsAnyOfKeywordIgnoreCase(keywords: [String]) -> Bool {
        for keyword in keywords {
            if self.lowercased()
                .contains(keyword.lowercased())
            {
                return true
            }
        }
        return false
    }

    public static func cardDetailsTitle() -> String {
        NSLocalizedString("title", comment: "").localized
    }

    public static func cardTitle() -> String {
        NSLocalizedString("card", comment: "").localized
    }

    public static func cardHolder() -> String {
        NSLocalizedString("cardholder", comment: "").localized
    }

    public static func cardholderPlaceholder() -> String {
        NSLocalizedString("cardholderPlaceholder", comment: "").localized
    }

    public static func cardNumberTitle() -> String {
        NSLocalizedString("cardNumber", comment: "").localized
    }

    public static func mmYY() -> String {
        NSLocalizedString("MM/YY", comment: "").localized
    }

    public static func cvcTitle() -> String {
        NSLocalizedString("CVC", comment: "").localized
    }

    public static func doneButtonTitle() -> String {
        NSLocalizedString("doneButton", comment: "").localized
    }

    public static func scanBackButtonTitle() -> String {
        NSLocalizedString("scanBackButton", comment: "").localized
    }

    public static func expiryTitle() -> String {
        NSLocalizedString("expiry", comment: "").localized
    }

    public static func cvcDescription() -> String {
        NSLocalizedString("cvcDescription", comment: "").localized
    }

    public static func incorrectLength() -> String {
        NSLocalizedString("incorrectLength", comment: "").localized
    }

    public static func incorrectCardNumber() -> String {
        NSLocalizedString("incorrectCardNumber", comment: "").localized
    }

    public static func incorrectExpiry() -> String {
        NSLocalizedString("incorrectExpiry", comment: "").localized
    }

    public static func incorrectCvc() -> String {
        NSLocalizedString("incorrectCvc", comment: "").localized
    }

    public static func incorrectCardholder() -> String {
        NSLocalizedString("incorrectCardholder", comment: "").localized
    }

    public static func switchViewTitle() -> String {
        NSLocalizedString("switchViewTitle", comment: "").localized
    }

    public static func newCard() -> String {
        NSLocalizedString("newCard", comment: "").localized
    }

    public static func editTitle() -> String {
        NSLocalizedString("edit", comment: "").localized
    }

    public static func saveTitle() -> String {
        NSLocalizedString("save", comment: "").localized
    }

    public static func payByCard() -> String {
        NSLocalizedString("payByCard", comment: "").localized
    }

    public static func addCard() -> String {
        NSLocalizedString("addCard", comment: "").localized
    }

    public static func allPaymentMethods() -> String {
        NSLocalizedString("allPaymentMethods", comment: "").localized
    }

    public static func payment() -> String {
        NSLocalizedString("payment", comment: "").localized
    }

    public static func cardNumber() -> String {
        NSLocalizedString("cardNumber", comment: "").localized
    }

    public static func pay() -> String {
        NSLocalizedString("pay", comment: "").localized
    }

    public static func allCards() -> String {
        NSLocalizedString("allCards", comment: "").localized
    }

    public static func yourCards() -> String {
        NSLocalizedString("yourCards", comment: "").localized
    }

    public static func removeBindingAlertTitle() -> String {
        NSLocalizedString("removeBindingAlertTitle", comment: "").localized
    }

    public static func removeBindingAlertDescription() -> String {
        NSLocalizedString("removeBindingAlertDescription", comment: "")
            .localized
    }

    public static func cancelTitle() -> String {
        NSLocalizedString("cancel", comment: "").localized
    }

    public static func removeTitle() -> String {
        NSLocalizedString("remove", comment: "").localized
    }

    public static func paymentMethod() -> String {
        NSLocalizedString("paymentMethod", comment: "").localized
    }

    public static func email() -> String {
        NSLocalizedString("email", comment: "").localized
    }

    public static func phoneNumber() -> String {
        NSLocalizedString("phoneNumber", comment: "").localized
    }

    public static func country() -> String {
        NSLocalizedString("country", comment: "").localized
    }

    public static func state() -> String {
        NSLocalizedString("state", comment: "").localized
    }

    public static func city() -> String {
        NSLocalizedString("city", comment: "").localized
    }

    public static func postalCode() -> String {
        NSLocalizedString("postalCode", comment: "").localized
    }

    public static func addressLine1() -> String {
        NSLocalizedString("addressLine1", comment: "").localized
    }

    public static func addressLine2() -> String {
        NSLocalizedString("addressLine2", comment: "").localized
    }

    public static func addressLine3() -> String {
        NSLocalizedString("addressLine3", comment: "").localized
    }
}
