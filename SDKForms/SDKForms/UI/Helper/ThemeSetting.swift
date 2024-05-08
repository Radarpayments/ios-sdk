//
//  ThemeSetting.swift
//  SDKForms
//
// 
//

import UIKit

final class ThemeSetting {
    
    static let shared = ThemeSetting()
    
    private var theme: Theme = .light
    
    private init() {}
    
    func setTheme(_ theme: Theme) {
        self.theme = theme
    }
    
    func getTheme() -> Theme {
        self.theme
    }
    
    func getThemeWithDefault(defaultTheme: Theme) -> Theme {
        if theme != defaultTheme { return theme }
        
        setTheme(defaultTheme)
        return defaultTheme
    }
    
    /*! Text color */
    func colorLabel() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        case .dark:
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        case .system:
            UIColor.systemColorLabelColor ?? UIColor()
        }
    }
    /*! Placeholder color */
    func colorPlaceholder() -> UIColor {
        UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1.00)
    }
    /*! Error color */
    func colorErrorLabel() -> UIColor {
        UIColor(red: 0.85, green: 0.09, blue: 0.09, alpha: 1.00)
    }
    /*! Background color */
    func colorTableBackground() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        case .dark:
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        case .system:
            UIColor.systemColorTableBackgroundColor ?? UIColor()
        }
    }
    /*! Cell color */
    func colorCellBackground() -> UIColor {
        colorTableBackground()
    }
    /*! Cell border color */
    func colorSeparator() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        case .dark:
            UIColor(red: 0.35, green: 0.35, blue: 0.36, alpha: 1.00)
        case .system:
            UIColor.systemColorSeparatarColor ?? UIColor()
        }
    }
    /*! Color text button */
    func colorButtonText() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        case .dark:
            UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        case .system:
            UIColor.systemColorButtonTextColor ?? UIColor()
        }
    }
    /*! Background button */
    func colorButtonBackground() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        case .dark:
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        case .system:
            UIColor.systemColorButtonBackgroundColor ?? UIColor()
        }
    }
    /*! Active TextField bottom line  */
    func colorActiveBorderTextView() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        case .dark:
            UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
        case .system:
            UIColor.systemActiveBorderTextColor ?? UIColor()
        }
    }
    /*! Inactive TextField bottom line  */
    func colorInactiveBorderTextView() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        case .dark:
            UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        case .system:
            UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        }
    }
    
    /*! Bank logo background  */
    func colorLogoBackground() -> UIColor {
        UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    }
    
    /* Bottom sheet background */
    func colorBottomSheetBackground() -> UIColor {
        switch theme {
        case .light:
            UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        case .dark:
            UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00)
        case .system:
            UIColor.systemBottomSheetBackgroundColor ?? UIColor()
        }
    }
}
