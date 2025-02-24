//
//  PaymentResult.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms

/// The result of a full payment cycle.
///
/// - Parameters:
///     - paymentId payment identifier.
///     - isSuccess payment finish status.
///     - exception error if exist.
public struct PaymentResult {

    public let paymentId: String
    public var isSuccess = false
    public let exception: SDKException?
    
    init(paymentId: String,
         isSuccess: Bool = false,
         exception: SDKException?) {
        self.paymentId = paymentId
        self.isSuccess = isSuccess
        self.exception = exception
    }

    init(paymentId: String,
         paymentResultData: PaymentResultData) {
        self.paymentId = paymentId
        self.isSuccess = paymentResultData.isSuccess
        self.exception = paymentResultData.exception
    }
}
