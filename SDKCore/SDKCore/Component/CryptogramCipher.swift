//
//  CryptogramCipher.swift
//  SDKCore
//
// 
//

import Foundation

 ///Interface for cryptogram encryptor.
protocol CryptogramCipher {
    
    /// Encrypt [data] by public key [key].
    /// - Returns: cryptogram.
    func encode(
        data: String,
        key: Key
    ) throws -> String
}
