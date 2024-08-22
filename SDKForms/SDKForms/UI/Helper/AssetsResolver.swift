//
//  CardLogoAssetsResolver.swift
//  SDKForms
//
// 
//

import UIKit
import SDKCore

final class AssetsResolver {
    
    private let paymentSystems: [String: String] = [
        "^3[47]\\d*$": "amex",
        "^(2131|1800|35)\\d*$": "jcb",
        "^(5[0678]|6304|6390|6054|6271|67)\\d*$": "maestro",
        "^(5[1-5]|222[1-9]|2[3-6]|27[0-1]|2720)\\d*$": "mastercard",
        "^4\\d*$": "visa",
        "^(6011|64[4-9]|65|6221[2-9][6-9]|6222[0-8][0-9][0-9]|62229[1-2][0-5])\\d$": "discover",
        "^(62[0-9]{14,17})$": "unionpay"
    ]
    
    func resolveByPan(pan: String, preferLight: Bool = false) -> String? {
        let cleanPan = pan.digitsOnly()
        
        let acceptedSystem = paymentSystems.keys
            .filter {
                let range = NSRange(location: 0, length: cleanPan.count)
                let regex = try? NSRegularExpression(pattern: $0)
                return !(regex?.matches(in: cleanPan, range: range).isEmpty ?? true)
            }
            .first
        
        if let acceptedSystem,
           var cardSystemLogo = paymentSystems[acceptedSystem] {
            
            cardSystemLogo.append(preferLight ? "-light" : "-dark")
            return cardSystemLogo
        }
        
        return nil
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
