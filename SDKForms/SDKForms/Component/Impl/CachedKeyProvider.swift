//
//  CachedKeyProvider.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Implementing a cached key provider.
///
/// - Parameters:
///     - keyProvider: key provider.
///     - sharedPreferences: cached key storage.
///     - maxExpiredTime: maximum key caching time.
final class CachedKeyProvider: KeyProvider {
    
    static let KEY_DEFAULT_MAX_EXPIRE: Int64 = 86_400_000
    
    private let keyProvider: KeyProvider
    private let maxExpiredTime: Int64 = KEY_DEFAULT_MAX_EXPIRE
    
    private var innerCachedKey: Key?
    
    private var cachedKey: Key? {
        get {
            if let innerCachedKey {
                return innerCachedKey
            }
            
            innerCachedKey = UserDefaults.loadKey()
            return innerCachedKey
        }
        set {
            if let newValue {
                UserDefaults.save(key: newValue)
            } else {
                UserDefaults.removeKey()
            }
            innerCachedKey = newValue
        }
    }
    
    public init(keyProvider: KeyProvider) {
        self.keyProvider = keyProvider
    }
    
    func provideKey() throws -> Key {
        let now = Date().timeIntervalSince1970

        if let key = cachedKey, key.expiration > Int64(now) {
            return key
        }
        
        cachedKey = nil
        do {
            var newKey = try keyProvider.provideKey()
            newKey.expiration = min(newKey.expiration, Int64(now) + maxExpiredTime)
            cachedKey = newKey
            
            return newKey
        } catch let error {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG,
                message: "provideKey(): Key provider based on the external url of the resource.",
                exception: KeyProviderException(message: "Error while load active keys", cause: error)
            )
            
            throw KeyProviderException(message: "Error while load active keys", cause: error)
        }
    }
}

extension UserDefaults {
    
    private static let CACHED_KEY = "CachedKey"
    
    static func loadKey() -> Key? {
        standard.object(forKey: CACHED_KEY) as? Key
    }
    
    static func save(key: Key) {
        standard.setValue(key, forKey: CACHED_KEY)
    }
    
    static func removeKey() {
        standard.removeObject(forKey: CACHED_KEY)
    }
}
