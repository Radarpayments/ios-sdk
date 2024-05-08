//
//  SDKNotConfigureException.swift
//  SDKPayment
//
// 
//

import SDKForms

///Error when Merchant is not configured to be used without 3DS2SDK.
///
/// - Parameters:
///     - message error description text.
///     - cause error reason.
final class SDKNotConfigureException: SDKException {}
