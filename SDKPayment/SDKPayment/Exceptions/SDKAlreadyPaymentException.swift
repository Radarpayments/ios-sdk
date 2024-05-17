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
public final class SDKAlreadyPaymentException: SDKException {}
