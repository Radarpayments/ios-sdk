//
//  ProcessBindingFormResponse.swift
//  SDKPayment
//
// 
//

import Foundation

/// Response DTO for requesting payment by binding card.
///
/// - Parameters:
///     - errorCode error code.
struct ProcessBindingFormResponse: Codable {
    let errorCode: Int
}
