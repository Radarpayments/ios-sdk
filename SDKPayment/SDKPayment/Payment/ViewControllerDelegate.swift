//
//  ViewControllerDelegate.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms

/// Interface describing viewController delegates methods.
protocol ViewControllerDelegate: AnyObject {
    
    /// Finish viewController and return result of the job.
    ///
    /// - Parameters:
    ///     - view view controller
    ///     - paymentData result of payment completion.
    func finishWithResult(paymentData: PaymentResultData)
    
    /// Getting a configuration object for the Payment SDK.
    ///
    /// - Returns: configuration object.
    func getPaymentConfig() -> SDKPaymentConfig
}
