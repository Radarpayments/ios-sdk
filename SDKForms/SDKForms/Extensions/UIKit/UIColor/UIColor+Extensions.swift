//
//  UIColor+Extensions.swift
//  SDKForms
//
// 
//

import UIKit

public extension UIColor {
    
    static var systemActiveBorderTextColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemActiveBorderTextView", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemActiveBorderTextView
        #endif
    }
    
    static var systemBottomSheetBackgroundColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemBottomSheetBackground", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemBottomSheetBackground
        #endif
    }
    
    static var systemColorButtonBackgroundColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemColorButtonBackground", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemColorButtonBackground
        #endif
    }
    
    static var systemColorButtonTextColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemColorButtonText", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemColorButtonText
        #endif
    }
    
    static var systemColorLabelColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemColorLabel", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemColorLabel
        #endif
    }
    
    static var systemColorSeparatarColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemColorSeparatar", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemColorSeparatar
        #endif
    }
    
    static var systemColorTableBackgroundColor: UIColor {
        #if SWIFT_PACKAGE
        UIColor(named: "systemColorTableBackground", in: .sdkFormsBundle, compatibleWith: .none) ?? UIColor()
        #else
        UIColor.systemColorTableBackground
        #endif
    }
}
