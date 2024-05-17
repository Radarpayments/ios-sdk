//
//  PaymentBottomSheetScreen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class PaymentBottomSheetScreen: BaseScreen {
    
    private var app: XCUIApplication
    private lazy var newCardCell = app.cells["Add new card"]
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func clickOnAddNewCard() -> Bool {
        performWithTimeout(element: newCardCell) { element in
            element.tap()
        }
    }
    
    func clickOnCard(_ text: String) -> Bool {
        performWithTimeout(element: app.cells[text]) { element in
            element.tap()
        }
    }
}
