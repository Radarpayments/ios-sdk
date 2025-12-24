//
//  SDKException.swift
//  SDKForms
//
// 
//

import Foundation

/// Basic error that can be returned in response when executing SDK methods.
///
/// - Parameters:
///     - message: error description.
///     - cause: the reason for the error.
open class SDKException: Error {
    
    public var message: String?
    public var cause: Error?
    
    public init(message: String? = nil, cause: Error? = nil) {
        self.message = message
        self.cause = cause
    }
}

/// Represents a user-initiated cancellation of the payment flow UI.
public final class SDKCancelledException: SDKException {}
