//
//  BaseScreen.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

class BaseScreen {
    
    func performWithTimeout(
        timeout: TimeInterval = 8,
        element: XCUIElement, action: (XCUIElement) -> Void
    ) -> Bool {
        var result = false
        
        if element.waitForExistence(timeout: timeout) {
            if element.exists {
                action(element)
                result = true
            }
        }
        
        return result
    }
}
