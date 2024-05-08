//
//  CardDeleteOptions.swift
//  SDKForms
//
// 
//

import Foundation

/// Possible options for removing a card in the process of creating a cryptogram.
public enum CardDeleteOptions: Codable {
    /// Remove card option, default value: Yes.
    case yesDelete
    /// Remove card option, default value: None.
    case noDelete
}
