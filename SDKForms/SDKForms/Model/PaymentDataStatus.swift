//
//  PaymentDataStatus.swift
//  SDKForms
//
// 
//

import Foundation

/// Possible states of data generation for making a payment.
public enum PaymentDataStatus: Codable {
    /// Payment canceled.
    case canceled
    /// Data successfully generated.
    case succeeded
    
    /// Checking for compliance with the [SUCCEEDED] status.
    /// - Returns: returns true if the status is [SUCCEEDED], otherwise false.
    func isSucceeded() -> Bool { self == .succeeded }
    
    /// Checking for compliance with the [CANCELED] status.
    /// - Returns: returns true if the status is [CANCELED], otherwise false.
    func isCanceled() -> Bool { self == .canceled }
}
