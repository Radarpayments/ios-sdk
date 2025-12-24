//
//  Theme.swift
//  SDKPayment
//
//
//

import Foundation

/// Possible use cases for themes.
internal enum Theme: Codable, Equatable {

    /// The current theme of the application.
    //    case `default`
    /// Light theme.
    case light
    /// Dark theme.
    case dark
    /// According to the theme of the system.
    case system
}
