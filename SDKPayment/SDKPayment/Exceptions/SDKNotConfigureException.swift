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
public final class SDKNotConfigureException: SDKException {}
