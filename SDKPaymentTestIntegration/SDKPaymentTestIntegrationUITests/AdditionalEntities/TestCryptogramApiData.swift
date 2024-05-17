//
//  TestCryptogramApiData.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation

struct TestCryptogramApiData: Codable {
 
    let seToken: String
    let mdOrder: String
    let holder: String
    let saveCard: Bool
}
