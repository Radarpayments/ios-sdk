//
//  CryptogramApiData.swift
//  SDKPayment
//
// 
//

import Foundation

/// An object containing data for API requests.
///
/// - Parameters:
///     - paymentToken cryptogram.
///     - mdOrder order number.
///     - holder first and last cardholder name.
///     - saveCard should saving a card.
struct CryptogramApiData: Codable {
    
    let paymentToken: String
    let mdOrder: String
    let holder: String
    var saveCard: Bool = false
    var fullPayerData: FullPayerData?
}
