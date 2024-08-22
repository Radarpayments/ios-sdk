//
//  CardFormDelegate.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms

/// Interface describing the operation of the card data entry form.
protocol CardFormDelegate: AnyObject {
    
    /// Method for starting a form with binding cards.
    ///
    /// - Parameters:
    ///     - mdOrder order number.
    ///     - bindingEnabled is card saving allowed (check mark pressed).
    ///     - bindingCards list of binding cards.
    ///     - cvcNotRequired cvc not required.
    ///     - bindingDeactivationEnabled possible to delete cards.
    ///     - googlePayConfig configuration for google pay payment.
   func openBottomSheet(
       mdOrder: String,
       bindingEnabled: Bool,
       bindingCards: [BindingItem],
       cvcNotRequired: Bool,
       bindingDeactivationEnabled: Bool,
       applePayPaymentConfig: ApplePayPaymentConfig?,
       sessionStatus: SessionStatusResponse
   ) throws
}
