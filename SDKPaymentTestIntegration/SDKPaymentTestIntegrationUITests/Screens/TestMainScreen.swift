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
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func clickOnCheckout() -> Bool {
        performWithTimeout(element: checkoutButton) { element in
            element.tap()
        }
    }
}
