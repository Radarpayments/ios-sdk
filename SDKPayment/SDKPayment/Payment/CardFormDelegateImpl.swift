//
//  CardFormDelegateImpl.swift
//  SDKPayment
//
// 
//

import UIKit
import SDKForms
import SDKCore

// Controller for payment cycle
final class CardFormDelegateImpl: CardFormDelegate {
    
    private var parentController: UINavigationController
    private weak var resultCryptogramCallback: (any ResultCryptogramCallback<CryptogramData>)!
    
    init(
        parentController: UINavigationController,
        resultCryptogramCallback: any ResultCryptogramCallback<CryptogramData>
    ) {
        self.parentController = parentController
        self.resultCryptogramCallback = resultCryptogramCallback
    }
    
    func openBottomSheet(
        mdOrder: String,
        bindingEnabled: Bool,
        bindingCards: [BindingItem],
        cvcNotRequired: Bool,
        bindingDeactivationEnabled: Bool,
        applePayPaymentConfig: ApplePayPaymentConfig?
    ) {
        let paymentConfig = PaymentConfigBuilder(order: mdOrder)
            .cards(cards: Set(bindingCards.toCards()))
            .storedPaymentMethodCVCRequired(required: !cvcNotRequired)
            .cardSaveOptions(options: bindingEnabled ? .yesByDefault : .hide)
            .cardDeleteOptions(options: bindingDeactivationEnabled ? .yesDelete : .noDelete)
            .displayApplePay(isDisplay: applePayPaymentConfig != nil)
            .registeredFrom(registeredFrom: .MSDK_PAYMENT)
            .build()
        
        SdkForms.shared.cryptogramWithBottomSheet(
            parent: parentController,
            config: paymentConfig,
            applePayPaymentConfig: applePayPaymentConfig,
            callbackHandler: resultCryptogramCallback
        )
    }
}

private extension Array where Element == BindingItem {
    
    func toCards() -> [Card] {
        self.map { $0.toCard() }
    }
}

private extension BindingItem {
    
    // TODO: - replace with two separated fields month and year.
    /// Example of the label filed in [BindingItem]: "654654***3843 12/24".
    func toCard() -> Card {
        let label = self.label.split(separator: " ")
            .compactMap { String($0) }

        if label.count > 1 {
            let expiryDate = Array(label[1].split(separator: "/"))
            if let expMonth = Int(expiryDate[0]), let expYear = Int(expiryDate[1]) {
                return Card(
                    pan: label[0],
                    bindingId: self.id,
                    expiryDate: ExpiryDate(
                        expYear: expYear,
                        expMonth: expMonth
                    )
                )
            }
        }

        return Card(
            pan: self.label,
            bindingId: self.id,
            expiryDate: nil
        )
    }
}
