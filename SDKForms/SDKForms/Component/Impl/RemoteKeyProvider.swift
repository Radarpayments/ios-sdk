//
//  RemoteKeyProvider.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Key provider based on the external url of the resource.
///
/// - Parameters:
///     - url: the address of the remote server providing an active encryption key.
///     - sslContext: SSLContext with a custom SSL certificate.
public final class RemoteKeyProvider: NSObject, KeyProvider {
    
    private let url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public func provideKey() throws -> Key {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "provideKey(): Key provider based on the external url of the resource.",
            exception: nil
        )
        
        let (keysInfo, _, error) = URLSession.shared.executeGet(urlString: url)
        guard let keysInfo = keysInfo else {
            Logger.shared.log(classMethod: type(of: self),
                              tag: Constants.TAG,
                              message: "Keys for tokens are not configured on remote server",
                              exception: KeyProviderException(message: "Keys for tokens are not configured on remote server", cause: error))
            throw KeyProviderException(message: "Keys for tokens are not configured on remote server", cause: error)
        }

        if let keys = try? JSONDecoder().decode(ActiveKeysDTO.self, from: keysInfo ?? Data()),
           let firstKey = keys.keys.first {
            return firstKey.toKey()
        }
        
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "provideKey(): Key provider based on the external url of the resource.",
            exception: KeyProviderException(message: "Error while load active keys", cause: error)
        )
        
        throw KeyProviderException(message: "Error while load active keys", cause: error)
    }
}

private struct ActiveKeysDTO: Codable {
    
    let keys: [ActiveKeyDTO]
}

private struct ActiveKeyDTO: Codable {
    
    let keyValue: String
    let protocolVersion: String
    let keyExpiration: Int64
    
    func toKey() -> Key {
        Key(
            value: keyValue,
            protocol: protocolVersion,
            expiration: keyExpiration
        )
    }
}
