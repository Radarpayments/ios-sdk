//
//  NewCardScreen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class NewCardScreen: BaseScreen {
    
    var cardNumberValue: String {
        cardNumberField.value as? String ?? ""
    }
    
    var cardExpiryValue: String {
        cardExpiryField.value as? String ?? ""
    }
    
    var cardCvcValue: String {
        cardCVCField.value as? String ?? ""
    }
    
    var phoneNumberValue: String {
        phoneNumberField?.value as? String ?? ""
    }
    
    var emailValue: String {
        emailField?.value as? String ?? ""
    }
    
    var countryValue: String {
        countryField?.value as? String ?? ""
    }
    
    var stateValue: String {
        stateField?.value as? String ?? ""
    }
    
    var postalCodeValue: String {
        postalCodeField?.value as? String ?? ""
    }
    
    var cityValue: String {
        cityField?.value as? String ?? ""
    }
    
    var addressLine1Value: String {
        addressLine1Field?.value as? String ?? ""
    }
    
    var addressLine2Value: String {
        addressLine2Field?.value as? String ?? ""
    }
    
    var addressLine3Value: String {
        addressLine3Field?.value as? String ?? ""
    }
    
    var cardNumberIsFocused: Bool {
        (cardNumberField.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    var cardExpiryIsFocused: Bool {
        (cardExpiryField.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    var cardCvcIsFocused: Bool {
        (cardCVCField.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    var cardHolderIsFocused: Bool {
        (cardHolderField?.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    var phoneNumberIsFocused: Bool {
        (phoneNumberField?.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    var cardHolderIsExist: Bool {
        cardHolderField?.exists ?? false
    }
    
    var phoneNumberFieldIsExists: Bool {
        phoneNumberField?.exists ?? false
    }
    
    var emailFieldIsExists: Bool {
        emailField?.exists ?? false
    }
    
    var countryFieldIsExists: Bool {
        countryField?.exists ?? false
    }
    
    var stateFieldIsExists: Bool {
        stateField?.exists ?? false
    }
    
    var postalCodeFieldIsExists: Bool {
        postalCodeField?.exists ?? false
    }
    
    var cityFieldIsExists: Bool {
        cityField?.exists ?? false
    }
    
    var addressLine1FieldIsExists: Bool {
        addressLine1Field?.exists ?? false
    }
    
    var addressLine2FieldIsExists: Bool {
        addressLine2Field?.exists ?? false
    }
    
    var addressLine3FieldIsExists: Bool {
        addressLine3Field?.exists ?? false
    }
    
    private var app: XCUIApplication
    
    private lazy var cardNumberField = app.textFields["Card number"]
    private lazy var cardExpiryField = app.textFields["MM/YY"]
    private lazy var cardCVCField = app.secureTextFields["CVC"]
    private lazy var cardHolderField: XCUIElement? = app.textFields["NAME"]
    
    private lazy var phoneNumberField: XCUIElement? = app.textFields["Phone number"]
    private lazy var emailField: XCUIElement? = app.textFields["Email"]
    private lazy var countryField: XCUIElement? = app.textFields["Country"]
    private lazy var stateField: XCUIElement? = app.textFields["State"]
    private lazy var postalCodeField: XCUIElement? = app.textFields["Postal code"]
    private lazy var cityField: XCUIElement? = app.textFields["City"]
    private lazy var addressLine1Field: XCUIElement? = app.textFields["Address line 1"]
    private lazy var addressLine2Field: XCUIElement? = app.textFields["Address line 2"]
    private lazy var addressLine3Field: XCUIElement? = app.textFields["Address line 3"]
    
    private lazy var actionButton = app.buttons["actionButton"]
    private lazy var backButton = app.buttons["Back"]
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func typeCardNumber(_ text: String) -> Bool {
        performWithTimeout(element: cardNumberField) { element in
            element.tap()
            element.typeText(text)
        }
    }
    
    func typeCardExpiry(_ text: String) -> Bool {
        performWithTimeout(element: cardExpiryField) { element in
            element.tap()
            element.typeText(text)
        }
    }
    
    func typeCardCVC(_ text: String) -> Bool {
        performWithTimeout(element: cardCVCField) { element in
            element.tap()
            element.typeText(text)
        }
    }
    
    func typeCardHolder(_ text: String) -> Bool {
        if let cardHolderField {
            return performWithTimeout(element: cardHolderField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typePhoneNumber(_ text: String) -> Bool {
        if let phoneNumberField {
            return performWithTimeout(element: phoneNumberField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeEmail(_ text: String) -> Bool {
        if let emailField {
            return performWithTimeout(element: emailField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeCountry(_ text: String) -> Bool {
        if let countryField {
            return performWithTimeout(element: countryField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeState(_ text: String) -> Bool {
        if let stateField {
            return performWithTimeout(element: stateField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typePostalCode(_ text: String) -> Bool {
        if let postalCodeField {
            return performWithTimeout(element: postalCodeField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeCity(_ text: String) -> Bool {
        if let cityField {
            return performWithTimeout(element: cityField) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeAddressLine1(_ text: String) -> Bool {
        if let addressLine1Field {
            return performWithTimeout(element: addressLine1Field) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeAddressLine2(_ text: String) -> Bool {
        if let addressLine2Field {
            return performWithTimeout(element: addressLine2Field) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func typeAddressLine3(_ text: String) -> Bool {
        if let addressLine3Field {
            return performWithTimeout(element: addressLine3Field) { element in
                element.tap()
                element.typeText(text)
            }
        }
        
        return false
    }
    
    func clickOnActionButton() -> Bool {
        performWithTimeout(element: actionButton) { element in
            element.tap()
        }
    }
    
    func fillOutForm(
        with card: TestCard,
        overrideCvc: String? = nil,
        overrideExpiry: String? = nil,
        phoneNumber: String? = nil,
        email: String? = nil
    ) -> Bool {
        let cardNumberFilled = typeCardNumber(card.pan)
        let cardExpiryFilled = typeCardExpiry(overrideExpiry ?? card.expiry)
        let cardCVCFilled = typeCardCVC(overrideCvc ?? card.cvc)
        
        var mobilePhoneFilled = true
        var emailFilled = true
        
        if let phoneNumber { mobilePhoneFilled = typePhoneNumber(phoneNumber) }
        
        if let email { emailFilled = typeEmail(email) }
        
        return cardNumberFilled
            && cardExpiryFilled
            && cardCVCFilled
            && mobilePhoneFilled
            && emailFilled
    }
    
    func fillOutMandatoryFields(
        country: String?,
        state: String?,
        postalCode: String?,
        city: String?,
        addressLine1: String?,
        addressLine2: String?,
        addressLine3: String?
    ) -> Bool {
        var countryIsFilled = true
        var stateIsFilled = true
        var postalCodeIsFilled = true
        var cityIsFilled = true
        var addressLine1IsFilled = true
        var addressLine2IsFilled = true
        var addressLine3IsFilled = true
        
        if let country { countryIsFilled = typeCountry(country) }
        if let state { stateIsFilled = typeState(state) }
        if let postalCode { postalCodeIsFilled = typePostalCode(postalCode) }
        if let city { cityIsFilled = typeCity(city) }
        if let addressLine1 { addressLine1IsFilled = typeAddressLine1(addressLine1) }
        if let addressLine2 { addressLine2IsFilled = typeAddressLine2(addressLine2) }
        if let addressLine3 { addressLine3IsFilled = typeAddressLine3(addressLine3) }
        
        return countryIsFilled
            && stateIsFilled
            && postalCodeIsFilled
            && cityIsFilled
            && addressLine1IsFilled
            && addressLine2IsFilled
            && addressLine3IsFilled
    }
    
    func clickOnBackButton() -> Bool {
        performWithTimeout(element: backButton) { element in
            element.tap()
        }
    }
}
