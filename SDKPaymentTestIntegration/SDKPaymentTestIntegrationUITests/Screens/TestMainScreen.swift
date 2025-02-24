//
//  TestMainScreen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class TestMainScreen: BaseScreen {
    
    var resultText: String {
        resultLabel.label
    }
    
    private var app: XCUIApplication
    
    private lazy var checkoutButton = app.buttons["Checkout"]
    private lazy var resultLabel = app.staticTexts["resultLabel"]
    private lazy var checkoutSessionButton = app.buttons["Checkout Session"]
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func clickOnCheckout() -> Bool {
        performWithTimeout(element: checkoutButton) { element in
            element.tap()
        }
    }
    
    func clickOnCheckoutSession() -> Bool {
        performWithTimeout(element: checkoutSessionButton) { element in
            element.tap()
        }
    }
}
