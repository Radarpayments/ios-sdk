//
//  TestProcessFormResponse.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation

struct TestProcessFormResponse: Codable {
    
    let errorCode: Int
    var is3DSVer2: Bool = false
}
