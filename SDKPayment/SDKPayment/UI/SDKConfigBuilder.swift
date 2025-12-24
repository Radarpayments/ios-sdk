//
//  SDKConfigBuilder.swift
//  SDKPayment
//
//
//

import Foundation
import SDKCore

/// Constructor for forming the SDK configuration.
final class SDKConfigBuilder {

    private var keyProvider: KeyProvider? = nil
    private var cardInfoProvider: CardInfoProvider = RemoteCardInfoProvider(
        url: "https://mrbin.io/bins/display",
        urlBin: "https://mrbin.io/bins/"
    )

    init() {}

    /// Set the remote key provider by url
    ///
    /// - Parameters:
    ///     - providerUrl: url address for receiving encryption keys
    func keyProviderUrl(providerUrl: String) throws -> SDKConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG_UI,
            message:
                "keyProviderUrl \(providerUrl): Set the remote key provider by url.",
            exception: nil
        )

        if self.keyProvider != nil {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG_UI,
                message: "keyProviderUrl \(providerUrl): Error",
                exception: SDKException(
                    message: "You should use only one key provider build-method"
                )
            )
            throw SDKException(
                message: "You should use only one key provider build-method")
        }
        self.keyProvider = RemoteKeyProvider(url: providerUrl)

        return self
    }

    /// Set the provider of the encryption key.
    ///
    /// - Parameters:
    ///     - provider: the encryption key provider to use.
    func keyProvider(provider: KeyProvider) throws -> SDKConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG_UI,
            message:
                "keyProvider \(provider): Set the provider of the encryption key.",
            exception: nil
        )

        if self.keyProvider != nil {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG_UI,
                message: "keyProvider \(provider): Error",
                exception: SDKException(
                    message: "You should use only one key provider build-method"
                )
            )
            throw SDKException(
                message: "You should use only one key provider build-method")
        }
        self.keyProvider = provider

        return self
    }

    /// Change the provider of card information.
    ///
    /// - Parameters:
    ///     - provider: Provider for getting information about the style and type of the card.
    func cardInfoProvider(provider: CardInfoProvider) -> SDKConfigBuilder {
        self.cardInfoProvider = provider

        return self
    }

    /// Creates a payment SDK configuration.
    ///
    /// - Returns: SDK configuration.
    func build() throws -> SDKConfig {
        if let keyProvider {
            return SDKConfig(
                keyProvider: keyProvider,
                cardInfoProvider: self.cardInfoProvider)
        }

        throw SDKException(message: "You must initialize keyProvider!")
    }
}
