//
//  LogDebug.swift
//  SDKPayment
//
// 
//

import Foundation

/// Restricted logging methods used in the Payment SDK.
final class LogDebug {
    
    static let shared = LogDebug()
    
    private init() {}
    
    ///Print logs if build is in debug mode.
    ///
    /// - Parameters:
    ///     - message the output line to the log.
    func logIfDebug(message: String) {
        #if DEBUG
        print("PAYRDRSDK", message)
        #endif
    }
}
