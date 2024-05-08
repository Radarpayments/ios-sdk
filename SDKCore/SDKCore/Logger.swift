//
//  Logger.swift
//  SDKCore
//
// 
//

import Foundation

/// Class for custom log.
public class Logger {

    public static let shared = Logger()
    public static let TAG = "SDK-Core"

    private var logInterfaces: [LogInterface] = []

    private init() {}

    public func addLogInterface(logger: LogInterface) {
        logInterfaces.append(logger)
    }

    public func log(classMethod: AnyClass, tag: String = TAG, message: String = "", exception: Error? = nil) {
        logInterfaces.forEach {
            $0.log(class: classMethod, tag: tag, message: message, exception: exception)
        }
    }
}
