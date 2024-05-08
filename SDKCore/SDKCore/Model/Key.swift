//
//  Key.swift
//  SDKCore
//
// 
//

import Foundation

/// Struct key description for performing encryption of payment data.
/// - Parameters:
///     - value: key value.
///     - protocol: protocol.
///     - expiration: expiration time.
public struct Key: Equatable {
    public let value: String
    public let `protocol`: String
    public var expiration: Int64
    
    public init(value: String, `protocol`: String, expiration: Int64) {
        self.value = value
        self.`protocol` = `protocol`
        self.expiration = expiration
    }
}
