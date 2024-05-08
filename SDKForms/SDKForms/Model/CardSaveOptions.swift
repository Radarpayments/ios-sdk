//
//  CardSaveOptions.swift
//  SDKForms
//
// 
//

import Foundation

/// Possible withdrawal options for saving the card after payment.
public enum CardSaveOptions: Codable {
    /// Save card option hidden.
    case hide
    /// Card save option, default value: Yes.
    case yesByDefault

    /// Card save option, default value: No.
    case noByDefault
}
