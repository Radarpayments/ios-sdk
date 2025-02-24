//
//  LogInterface.swift
//  SDKCore
//
// 
//

import Foundation

/// Interface for custom log.
public protocol LogInterface {
    /// Method signature for implementing logs.
    ///
    /// - Parameters:
    ///     - tag: module tag.
    ///     - Class: class where the method was called.
    ///     - Message: log message.
    ///     - Exception: caused exception.
    func log(class: Any, tag: String, message: String, exception: Error?)
}
