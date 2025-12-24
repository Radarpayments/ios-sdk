//
//  Bundle+Extensions.swift
//  SDKPayment
//
//
//

import Foundation

public extension Bundle {
    
    static var sdkPaymentBundle: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle.main
#endif
    }
}
