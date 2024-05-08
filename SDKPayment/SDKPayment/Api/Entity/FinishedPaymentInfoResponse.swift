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
struct FinishedPaymentInfoResponse: Codable {

    let status: String?
    let paymentDate: String?
    let approvalCode: String?
    let terminalId: String?
    let refNum: String?
    let panMasked: String?
    let formattedAmount: String?
    let actionCodeDescription: String?
    
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
    }
}
