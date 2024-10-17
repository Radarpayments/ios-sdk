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
///     - mdOrder order number.
///     - status payment status.
public struct PaymentResult {

    public let mdOrder: String
    public var isSuccess = false
    public let exception: SDKException?
    
    init(
        mdOrder: String,
        isSuccess: Bool = false,
        exception: SDKException? = nil
    ) {
        self.mdOrder = mdOrder
        self.isSuccess = isSuccess
        self.exception = exception
    }
}
