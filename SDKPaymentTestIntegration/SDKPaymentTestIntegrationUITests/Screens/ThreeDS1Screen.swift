//
//  ThreeDS1Screen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class ThreeDS1Screen: BaseScreen {
    
    private var app: XCUIApplication!
    
    private lazy var successButton = app.buttons["Success"]
    private lazy var failButton = app.buttons["Fail"]
    private lazy var returnLink = app.links["Return to Merchant"]
    
    init(app: XCUIApplication!) {
        self.app = app
    }
    
    func clickOnSuccess() -> Bool {
        performWithTimeout(element: successButton) { element in
            element.tap()
        }
    }
    
    func clickOnFail() -> Bool {
        performWithTimeout(element: failButton) { element in
            element.tap()
        }
    }
    
    func clickOnReturnToMerchant() -> Bool {
        performWithTimeout(element: returnLink) { element in
            element.tap()
        }
    }
}
