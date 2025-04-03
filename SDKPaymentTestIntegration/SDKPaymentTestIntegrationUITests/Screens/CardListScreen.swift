//
//  CardListScreen.swift
//  SDKPaymentTestIntegration
//

import Foundation
import XCTest

final class CardListScreen: BaseScreen {
    
    private var app: XCUIApplication
    private lazy var deleteButton = app.buttons["Delete"]
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func swipeOnSavedCard(_ cardNumber: String) -> Bool {
        let cardCell = app.cells[cardNumber]
        
        return performWithTimeout(element: cardCell) { element in
            element.swipeLeft()
        }
    }
    
    func tapToDelete() -> Bool {
        performWithTimeout(element: deleteButton) { element in
            element.tap()
        }
    }
}
