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
    
    var cardHolderIsExist: Bool {
        cardHolderField?.exists ?? false
    }
    
    private var app: XCUIApplication
    
    private lazy var cardNumberField = app.textFields["Card number"]
    private lazy var cardExpiryField = app.textFields["MM/YY"]
    private lazy var cardCVCField = app.secureTextFields["CVC"]
    private lazy var cardHolderField: XCUIElement? = app.textFields["NAME"]
    
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
    
    func clickOnActionButton() -> Bool {
        performWithTimeout(element: actionButton) { element in
            element.tap()
        }
    }
    
    func fillOutForm(
        with card: TestCard,
        overrideCvc: String? = nil,
        overrideExpiry: String? = nil
    ) -> Bool {
        typeCardNumber(card.pan) 
            && typeCardExpiry(overrideExpiry ?? card.expiry)
            && typeCardCVC(overrideCvc ?? card.cvc)
    }
    
    func clickOnBackButton() -> Bool {
        performWithTimeout(element: backButton) { element in
            element.tap()
        }
    }
}
