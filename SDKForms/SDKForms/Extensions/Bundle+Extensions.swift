//
//  Bundle+Extensions.swift
//  SDKForms
//
// 
//

import Foundation

public extension Bundle {
    
    static var sdkFormsBundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle.main
        #endif
    }
}
