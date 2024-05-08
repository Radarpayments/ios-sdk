//
//  SDKAlreadyPaymentException.swift
//  SDKPayment
//
// 
//

import SDKForms

/// An error that occurs when trying to re-pay order.
///
/// - Parameters:
///     - message error description text.
///     - cause error reason.
final class SDKAlreadyPaymentException: SDKException {}
