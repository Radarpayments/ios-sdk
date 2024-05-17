//
//  TestClientIdHelper.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation

struct TestClientIdHelper {
    
    var startClientId: Int64
    
    private lazy var clientIdShift = startClientId
    
    init(startClientId: Int64) {
        self.startClientId = startClientId
    }
    
    mutating func getNewTestClientId() -> String {
        clientIdShift += 1
        return String(clientIdShift)
    }
}
