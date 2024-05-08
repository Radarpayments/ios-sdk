//
//  KeyProviderException.swift
//  SDKForms
//
// 
//

import Foundation

/// An error that occurs when obtaining an encryption key.
///
/// - Parameters:
///     - message: error description text.
///     - cause: error reason.
struct KeyProviderException: Error {
    
    let message: String
    let cause: Error?
}
