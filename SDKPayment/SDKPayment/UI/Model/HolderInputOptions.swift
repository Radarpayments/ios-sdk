//
//  HolderInputOptions.swift
//  SDKPayment
//
//
//

import Foundation

/// Possible options for displaying the cardholder input field.
internal enum HolderInputOptions: Codable {

    /// Cardholder entry option is hidden.
    case hide
    /// Owner input option displayed.
    case visible
}
