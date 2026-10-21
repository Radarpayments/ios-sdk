//
//  CardLogoAssetsResolver.swift
//  SDKPayment
//
//
//

import UIKit
import SDKCore

final class AssetsResolver {

    func resolveByPan(pan: String, preferLight: Bool = false) -> String? {
        guard let assetName = CardNetworkResolver.resolve(pan).assetName else { return nil }

        return assetName + (preferLight ? "-light" : "-dark")
    }

    func resolveAddCard(theme: Theme) -> String? {
        var addCardImageName = "add-card"

        addCardImageName.append(assetSuffix(forTheme: theme))

        return addCardImageName
    }

    func resolveClose(theme: Theme) -> String? {
        var closeImageName = "close"

        closeImageName.append(assetSuffix(forTheme: theme))

        return closeImageName
    }

    private func assetSuffix(forTheme theme: Theme) -> String {
        switch theme {
        case .light:
            return "-light"
        case .dark:
            return "-dark"
        case .system:
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .dark:
                return "-dark"
            default:
                return "-light"
            }
        }
    }
}
