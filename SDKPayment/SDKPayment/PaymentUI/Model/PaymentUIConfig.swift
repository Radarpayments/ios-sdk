//
//  PaymentUIConfig.swift
//  SDKPayment
//
//
//

import Foundation

/// SDK configuration options class.
///
/// - Parameters:
///     - keyProvider: the encryption key provider to use.
///     - cardInfoProvider: the card style and type information provider to use.
internal struct PaymentUIConfig {

    let keyProvider: KeyProvider
    let cardInfoProvider: CardInfoProvider
}
