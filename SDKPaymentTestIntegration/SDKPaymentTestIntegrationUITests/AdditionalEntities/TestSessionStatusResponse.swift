//
//  TestSessionStatusResponse.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import SDKPayment

struct TestSessionStatusResponse: Codable {
    
    var bindingItems = [TestBindingItem]()
}
