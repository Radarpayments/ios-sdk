//
//  PaymentApi.swift
//  SDKPayment
//
// 
//

import Foundation

/// Interface for carrying out a full payment cycle.
protocol PaymentApi {
    
    ///API method for getting information about order status .
    ///
    /// - Parameters:
    ///    - mdOrder order number.
    /// - Returns: [SessionStatusResponse] order status data.
    func getSessionStatus(mdOrder: String) throws -> SessionStatusResponse

    /// API method for making payments with a new card without 3DS.
    ///
    /// - Parameters:
    ///     - cryptogramApiData cryptogram and data for its creation.
    /// - Returns: [ProcessFormResponse] payment status data for first payment try.
    func processForm(
        cryptogramApiData: CryptogramApiData,
        threeDSSDK: Bool
    ) throws -> ProcessFormResponse

    ///API method for making payments with a binding card.
    ///
    /// - Parameters:
    ///    - cryptogramApiData cryptogram and data for its creation.
    ///- Returns: [ProcessFormResponse] payment status data for first payment try.
    func processBindingForm(
        cryptogramApiData: CryptogramApiData,
        threeDSSDK: Bool
    ) throws -> ProcessFormResponse

     ///API method for making card payments with 3DS.
     ///
    /// - Parameters:
     ///    - cryptogramApiData cryptogram and data for its creation.
     ///    - threeDSParams 3DS parameters.
     /// - Returns: [ProcessFormSecondResponse] payment status data for new card for second payment try.
    func processFormSecond(
        cryptogramApiData: CryptogramApiData,
        threeDSParams: PaymentApiImpl.PaymentThreeDSInfo
    ) throws -> ProcessFormSecondResponse

     ///API method for making payments with a binding card with 3DS.
     ///
    /// - Parameters:
     ///    - cryptogramApiData cryptogram and data for its creation.
     ///    - threeDSParams 3DS parameters.
     ///- Returns: [ProcessFormSecondResponse] payment status data for binding card for second payment try.
    func processBindingFormSecond(
        cryptogramApiData: CryptogramApiData,
        threeDSParams: PaymentApiImpl.PaymentThreeDSInfo
    ) throws -> ProcessFormSecondResponse

    /// API method for completing payment.
    ///
    /// - Parameters:
    ///     - threeDSServerTransId server transaction id for challenge flow.
    func finish3dsVer2PaymentAnonymous(threeDSServerTransId: String) throws

    ///API method for getting payment information.
    ///
    /// - Parameters:
    ///     - orderId order number.
    /// - Returns: [FinishedPaymentInfoResponse] payment finish status data.
    func getFinishedPaymentInfo(orderId: String) throws -> FinishedPaymentInfoResponse
    
    /// API method for making payment with an ApplePay payment
    ///
    /// - Parameters:
    ///     - cryptogramApplePayApiData cryptogram created by ApplePay
    /// - Returns: [ProcessFOrmApplePayResponse] payment status data
    func processApplePay(cryptogramApplePayApiData: CryptogramApplePayApiData) throws -> ProcessFormApplePayResponse

     ///API method for unbinding card by id.
     ///
    /// - Parameters:
     ///    - bindingId card identifier.
     ///    - mdOrder order identifier.
     /// - Returns: [UnbindCardResponse] card unbind result.
    func unbindCardAnonymous(bindingId: String, mdOrder: String) throws -> UnbindCardResponse
}
