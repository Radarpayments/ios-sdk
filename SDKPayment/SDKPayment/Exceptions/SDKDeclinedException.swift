//
//  SDKDeclinedException.swift
//  SDKPayment
//
// 
//

import SDKForms

/// Error when paying for a canceled order.
///
/// - Parameters:
///     - message error description text.
///     - cause error reason.
public final class SDKDeclinedException: SDKException {}
