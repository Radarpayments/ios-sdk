//
//  ViewControllerDelegate.swift
//  SDKPayment
//
//
//

import Foundation

/// Interface describing viewController delegates methods.
protocol ViewControllerDelegate: AnyObject {

    /// Finish viewController and return result of the job.
    ///
    /// - Parameters:
    ///     - view view controller
    ///     - paymentData result of payment completion.
    func finishWithResult(paymentData: PaymentResultData)

    /// Hides the preloader shown during payment processing.
    func hidePaymentPreloader()

    /// Getting a configuration object for the Payment SDK.
    ///
    /// - Returns: configuration object.
    func getPaymentConfig() -> SDKPaymentConfig
}
