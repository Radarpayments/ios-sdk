//
//  RSACryptogramCipher.swift
//  SDKCore
//
// 
//

import Foundation

public enum CryptogramCipherError: Error {
    case keyCreationFailed
    case algorithmNotSupported
    case encryptionFailed
}

/// Implementation of cryptogram encryptor.
final class RSACryptogramCipher: CryptogramCipher {
    
    init() {}

    func encode(data: String, key: Key) throws -> String {
        guard key.protocol == "RSA",
              let keyPem = key.value.pemKeyContent().data(using: .utf8),
              let keyBytes = Data(base64Encoded: keyPem) else {
            throw CryptogramCipherError.keyCreationFailed
        }
        
        let attributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: keyBytes.count * 8)
        ]
        
        guard let keyData = SecKeyCreateWithData(keyBytes as CFData, attributes as CFDictionary, nil) else {
            throw CryptogramCipherError.keyCreationFailed
        }
        
        let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
        
        guard SecKeyIsAlgorithmSupported(keyData, .encrypt, algorithm) else {
            throw CryptogramCipherError.algorithmNotSupported
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(keyData, algorithm, data.data(using: .utf8)! as CFData, &error) else {
            throw CryptogramCipherError.encryptionFailed
        }
        
        return (encryptedData as Data).base64EncodedString()
    }
}
