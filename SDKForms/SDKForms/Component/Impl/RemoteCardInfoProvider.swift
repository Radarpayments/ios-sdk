//
//  RemoteCardInfoProvider.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Implementation of the provider of obtaining information about the card from a remote server.
///
/// - Parameters:
///     - url: method address for getting information.
///     - urlBin: prefix for getting binary data.
///     - sslContext: SSLContext with a custom SSL certificate.
final class RemoteCardInfoProvider: CardInfoProvider {
    
    private let url: String
    private let urlBin: String
    // TODO: - Figure out with cert
    private let sslContext: SSLContext?
    
    init(
        url: String,
        urlBin: String,
        sslContext: SSLContext? = nil
    ) {
        self.url = url
        self.urlBin = urlBin
        self.sslContext = sslContext
    }
    
    func resolve(bin: String) throws -> FormsCardInfo {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "resolve: \(bin)",
            exception: nil
        )
        
        let body = [ "bin": bin ]
        let (cardInfoData, _, error) = URLSession.shared.executePost(urlString: url, body: body)

        if var cardInfo = try? JSONDecoder().decode(FormsCardInfo.self, from: cardInfoData ?? Data()) {
            cardInfo.logoMini = urlBin + cardInfo.logoMini
            return cardInfo
        }
        
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "resolve: \(bin): Error",
            exception: CardInfoProviderException(message: "Error while load card info", cause: error)
        )
        
        throw CardInfoProviderException(message: "Error while load card info", cause: error)
    }
}
