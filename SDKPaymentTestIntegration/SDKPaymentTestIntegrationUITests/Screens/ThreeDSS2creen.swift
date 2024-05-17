//
//  ThreeDSS2creen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class ThreeDSS2creen: BaseScreen {
    
    private var app: XCUIApplication!
    
    private lazy var smsCodeInput = app.textFields.firstMatch
    private lazy var confirmButton = app.buttons["Confirm"]
    
    init(app: XCUIApplication!) {
        self.app = app
    }
    
    func typeSMSCode(_ text: String) -> Bool {
        performWithTimeout(element: smsCodeInput) { element in
            element.typeText(text)
        }
    }
    
    func clickOnConfirmButton() -> Bool {
        performWithTimeout(element: confirmButton) { element in
            element.tap()
        }
    }
}
