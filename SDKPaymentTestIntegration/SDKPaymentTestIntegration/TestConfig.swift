//
//  TestConfig.swift
//  SDKPaymentIntegration
//
//
//

import Foundation


final class TestConfig {
    
    static let shared = TestConfig()
    
    var environment: String = ""
    
    private init() {}
}
