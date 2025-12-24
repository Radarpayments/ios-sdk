//
//  PaymentUIConfigBuilder.swift
//  SDKPayment
//
//
//

import Foundation
import SDKCore

/// Constructor for forming the PaymentUI configuration.
final class PaymentUIConfigBuilder {

    private var keyProvider: KeyProvider? = nil
    private var cardInfoProvider: CardInfoProvider = RemoteCardInfoProvider(
        url: Constants.URL_CARD_INFO_BIN_DISPLAY,
        urlBin: Constants.URL_CARD_INFO_BIN
    )

    init() {}

    /// Set the remote key provider by url
    ///
    /// - Parameters:
    ///     - providerUrl: url address for receiving encryption keys
    func keyProviderUrl(providerUrl: String) throws -> PaymentUIConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG_UI,
            message: "keyProviderUrl \(providerUrl): Set the remote key provider by url.",
            exception: nil
        )

        if self.keyProvider != nil {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG_UI,
                message: "keyProviderUrl \(providerUrl): Error",
                exception: SDKException(message: "You should use only one key provider build-method")
            )

            throw SDKException(message: "You should use only one key provider build-method")
        }

        self.keyProvider = RemoteKeyProvider(url: providerUrl)

        return self
    }

    /// Set the provider of the encryption key.
    ///
    /// - Parameters:
    ///     - provider: the encryption key provider to use.
    func keyProvider(provider: KeyProvider) throws -> PaymentUIConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG_UI,
            message: "keyProvider \(provider): Set the provider of the encryption key.",
            exception: nil
        )

        if self.keyProvider != nil {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG_UI,
                message: "keyProvider \(provider): Error",
                exception: SDKException(message: "You should use only one key provider build-method")
            )

            throw SDKException(message: "You should use only one key provider build-method")
        }

        self.keyProvider = provider

        return self
    }

    /// Change the provider of card information.
    ///
    /// - Parameters:
    ///     - provider: Provider for getting information about the style and type of the card.
    func cardInfoProvider(provider: CardInfoProvider) -> PaymentUIConfigBuilder {
        self.cardInfoProvider = provider

        return self
    }

    /// Creates a PaymentUI configuration.
    ///
    /// - Returns: PaymentUI configuration.
    func build() throws -> PaymentUIConfig {
        if let keyProvider {
            return PaymentUIConfig(
                keyProvider: keyProvider,
                cardInfoProvider: self.cardInfoProvider
            )
        }

        throw SDKException(message: "You must initialize keyProvider!")
    }
}
