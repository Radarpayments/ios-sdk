//
//  CardInfoProviderException.swift
//  SDKForms
//
// 
//

import Foundation

/// An error that occurs when obtaining information about the card.
///
/// - Parameters:
///     - message: error description text.
///     - cause: error reason.
struct CardInfoProviderException: Error {
    
    let message: String
    let cause: Error?
}
