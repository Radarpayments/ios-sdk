//
//  PaymentConfig.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Payment configuration.
///
/// - Parameters:
///     - order: order ID for payment .
///     - cardSaveOptions: setting the option to link a new card after payment.
///     - holderInputOptions: setting the cardholder input option.
///     - cameraScannerOptions: setting the option to scan the card data through the camera.
///     - nfcScannerOptions: setting option to scan card data via NFC.
///     - theme: customize the interface theme.
///     - cards: list of linked cards.
///     - uuid: payment id.
///     - timestamp: time of payment.
///     - locale: locale in which the payment form should work.
///     - buttonText: the text of the payment button.
///     - storedPaymentMethodCVCRequired: mandatory entry of CVC paying with a previously saved card.
///     - cardDeleteOptions: the option to remove the card.
///     - cardsToDelete: the list of cards to be removed that the user has selected.
public struct PaymentConfig: Codable {
    
    var order: String = ""
    let cardSaveOptions: CardSaveOptions
    let holderInputOptions: HolderInputOptions
    let cameraScannerOptions: CameraScannerOptions
    let theme: Theme
    let cards: Set<Card>
    let uuid: String
    let timestamp: Int64
    let locale: Locales
    let buttonText: String?
    let storedPaymentMethodCVCRequired: Bool
    let cardDeleteOptions: CardDeleteOptions
    var cardsToDelete = Set<Card>()
    var displayApplePay = false
    var registeredFrom: MSDKRegisteredFrom = .MSDK_FORMS
    let editingBindingsIsEnabled: Bool
}
