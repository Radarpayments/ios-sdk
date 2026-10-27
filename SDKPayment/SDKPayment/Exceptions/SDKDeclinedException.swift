//
//  SDKDeclinedException.swift
//  SDKPayment
//
//
//

/// The payment was declined: by the issuer, by 3-D Secure, by the gateway, or in a previous payment attempt.
///
/// - Parameters:
///     - message error text for the payer, from the gateway.
///     - cause error reason.
///     - actionCode gateway result code of the payment attempt, e.g. "116".
///     - errorType gateway error type of the payment attempt, e.g. "INSUFFICIENT_FUNDS".
public final class SDKDeclinedException: SDKException {

    public let actionCode: String?
    public let errorType: String?

    public init(message: String? = nil, cause: Error? = nil, actionCode: String? = nil, errorType: String? = nil) {
        self.actionCode = actionCode
        self.errorType = errorType
        super.init(message: message, cause: cause)
    }
}
