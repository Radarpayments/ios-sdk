//
//  DefaultCryptogramProcessor.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Implementation of a processor for forming a cryptogram.
///
/// - Parameters:
///     - keyProvider: encryption key provider.
///     - paymentStringProcessor: pay line generation processor.
final class DefaultCryptogramProcessor: CryptogramProcessor {    
    
    private let keyProvider: KeyProvider
    private let paymentStringProcessor: PaymentStringProcessor
    private let cryptogramCipher: CryptogramCipher
    
    init(
        keyProvider: KeyProvider,
        paymentStringProcessor: PaymentStringProcessor,
        cryptogramCipher: CryptogramCipher
    ) {
        self.keyProvider = keyProvider
        self.paymentStringProcessor = paymentStringProcessor
        self.cryptogramCipher = cryptogramCipher
    }
    
    func create(
        order: String = "",
        timestamp: Int64,
        uuid: String,
        cardInfo: CoreCardInfo,
        registeredFrom: MSDKRegisteredFrom
    ) throws -> String {
        let key = try keyProvider.provideKey()
        let paymentString = paymentStringProcessor.createPaymentString(
            order: order,
            timestamp: timestamp,
            uuid: uuid,
            cardInfo: cardInfo,
            registeredFrom: registeredFrom
        )
        
        return try cryptogramCipher.encode(data: paymentString, key: key)
    }
}
