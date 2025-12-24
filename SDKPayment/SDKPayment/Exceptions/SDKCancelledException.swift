//
//  SDKCancelledException.swift
//  SDKPayment
//
//
//

/// Represents a user-initiated cancellation of the payment flow UI.
///
/// - Parameters:
///     - message error description text.
///     - cause error reason.
public final class SDKCancelledException: SDKException {}
