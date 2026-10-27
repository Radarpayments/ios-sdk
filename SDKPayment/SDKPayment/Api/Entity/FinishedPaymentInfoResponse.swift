//
//  FinishedPaymentInfoResponse.swift
//  SDKPayment
//
//
//

import Foundation

/// Response DTO for status information about result of finish payment process.
///
/// - Parameters:
///     - status payment status.
///     - paymentDate date of payment.
///     - approvalCode transaction code.
///     - terminalId terminal identifier.
///     - refNum transaction rm.
///     - panMasked masked card number.
///     - formattedAmount formatted order amount in order currency .
///     - actionCodeDescription order code description .
///     - actionCode result code of the last payment attempt, a number or a string depending on the gateway.
///     - displayErrorMessage error text for the payer, in the requested language.
///     - errorTypeName error type of the last payment attempt, e.g. INSUFFICIENT_FUNDS.
struct FinishedPaymentInfoResponse: Codable {

    let status: String?
    let paymentDate: String?
    let approvalCode: String?
    let terminalId: String?
    let refNum: String?
    let panMasked: String?
    let formattedAmount: String?
    let actionCodeDescription: String?
    let actionCode: String?
    let displayErrorMessage: String?
    let errorTypeName: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.status = try? container.decodeIfPresent(String.self, forKey: .status)
        self.paymentDate = try? container.decodeIfPresent(String.self, forKey: .paymentDate)
        self.approvalCode = try? container.decodeIfPresent(String.self, forKey: .approvalCode)
        self.terminalId = try? container.decodeIfPresent(String.self, forKey: .terminalId)
        self.refNum = try? container.decodeIfPresent(String.self, forKey: .refNum)
        self.panMasked = try? container.decodeIfPresent(String.self, forKey: .panMasked)
        self.formattedAmount = try? container.decodeIfPresent(String.self, forKey: .formattedAmount)
        self.actionCodeDescription = try? container.decodeIfPresent(String.self, forKey: .actionCodeDescription)
        self.actionCode = (try? container.decodeIfPresent(String.self, forKey: .actionCode))
            ?? (try? container.decodeIfPresent(Int.self, forKey: .actionCode)).map(String.init)
        self.displayErrorMessage = try? container.decodeIfPresent(String.self, forKey: .displayErrorMessage)
        self.errorTypeName = try? container.decodeIfPresent(String.self, forKey: .errorTypeName)
    }
}

extension FinishedPaymentInfoResponse {

    // Right after a decline the order can still be CREATED: the attempt result is in actionCode.
    func failureException() -> SDKException {
        let declined = status?.containsAnyOfKeywordIgnoreCase(keywords: OrderStatuses.payedCouldNotBeCompleted) == true
            || (actionCode != nil && actionCode != "0")

        if declined {
            return SDKDeclinedException(
                message: displayErrorMessage ?? actionCodeDescription,
                actionCode: actionCode,
                errorType: errorTypeName
            )
        }

        return SDKTransactionException(message: "Payment was not completed, order status: \(status ?? "unknown")")
    }
}
