//
//  KeyProvider.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Key provider interface for encrypting payment information.
public protocol KeyProvider {
    
    /// Returns an active key for encrypting payment information.
    ///
    /// - Returns: active key.
    func provideKey() throws -> Key
}
