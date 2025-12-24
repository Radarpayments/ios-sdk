//
//  UIColor+Extensions.swift
//  SampleApp
//

import UIKit

extension UIColor {
    /// Returns a semantic label color that adapts to light/dark mode (iOS 13+) or black (iOS 12)
    static var adaptiveLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }

    /// Returns a semantic background color that adapts to light/dark mode (iOS 13+) or white (iOS 12)
    static var adaptiveBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    /// Returns a semantic secondary background color that adapts to light/dark mode (iOS 13+) or light gray (iOS 12)
    static var adaptiveSecondaryBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        } else {
            return UIColor(white: 0.95, alpha: 1.0)
        }
    }

    /// Returns a semantic separator color that adapts to light/dark mode (iOS 13+) or light gray (iOS 12)
    static var adaptiveSeparator: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return UIColor(white: 0.86, alpha: 1.0)
        }
    }

    /// Returns a semantic gray color for backgrounds that adapts to light/dark mode (iOS 13+) or systemGray (iOS 12)
    static var adaptiveGrayBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray5
        } else {
            return .systemGray
        }
    }
}
