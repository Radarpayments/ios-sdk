//
//  CradInfoProvider.swift
//  SDKForms
//
// 
//

import Foundation

/// Interface for obtaining information about the card by its number.
public protocol CardInfoProvider {
    
    /// Method of obtaining information about a card by its number.
    ///
    /// - Parameters:
    ///     - bin: card number or first 6-8 digits of the number.
    func resolve(bin: String) throws -> FormsCardInfo
}
