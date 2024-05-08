//
//  TokenResult.swift
//  SDKCore
//
// 
//

import Foundation

/// Token description.
/// 
/// - Parameters:
///     - token: token as string.
///     - errors: error while generating token.
public struct TokenResult {
    
    public var token: String? = nil
    public var errors: Dictionary<ParamField, String> = [:]

    private init(token: String?, errors: Dictionary<ParamField, String>) {
        self.token = token
        self.errors = errors
    }

    public init(token: String?) {
        self.token = token
    }

    public init(errors: Dictionary<ParamField, String>) {
        self.errors = errors
    }
}
