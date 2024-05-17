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
    
    private var app: XCUIApplication
    
    private lazy var cardNumberField = app.textFields["Card number"]
    private lazy var cardExpiryField = app.textFields["MM/YY"]
    private lazy var cardCVCField = app.secureTextFields["CVC"]
    
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
