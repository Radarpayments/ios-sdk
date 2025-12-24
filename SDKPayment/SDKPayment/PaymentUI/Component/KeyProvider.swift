//
//  KeyProvider.swift
//  SDKPayment
//
//
//

import Foundation
import SDKCore

/// Key provider interface for encrypting payment information.
internal protocol KeyProvider {

    /// Returns an active key for encrypting payment information.
    ///
    /// - Returns: active key.
    func provideKey() throws -> Key
}
