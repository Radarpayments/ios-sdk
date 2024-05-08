//
//  LuhnStringRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule for checking the string value of the card number against the Luhn algorithm .
///
/// - Parameters:
///     - code: error code.
///     - message: the message displayed in case of an error after checking by the Luhn algorithm.
class LuhnStringRule: BaseValidationRule {

    typealias DATA = String

    private let code: String
    private let message: String

    init(code: String, message: String) {
        self.code = code
        self.message = message
    }

    func validateForError(data: String) -> ValidationResult {
        let reversedInts = data.reversed().compactMap { Int(String($0)) }

        let isValid = reversedInts.enumerated()
            .map { index, digit in
                switch index % 2 {
                case 0: return digit
                case _ where digit < 5: return digit * 2
                default: return digit * 2 - 9
                }
            }
            .reduce(0, +) % 10 == 0

        return !isValid 
            ? ValidationResult.error(errorCode: code, errorMessage: message)
            : .VALID
    }
}
