//
//  StringLengthRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule for checking a string value for a range of number of characters.
///
/// - Parameters:
///     - code: error code.
///     - message: message displayed if the string length is out of range.
///     - minLength: minimum allowed line length.
///     - maxLength: maximum allowed line length.
class StringLengthRule: BaseValidationRule {
    
    typealias DATA = String

    private let code: String
    private let message: String
    private let minLength: Int
    private let maxLength: Int

    init(
        code: String,
        message: String,
        minLength: Int = 0,
        maxLength: Int = Int.max
    ) {
        self.code = code
        self.message = message
        self.minLength = minLength
        self.maxLength = maxLength
    }

    func validateForError(data: String) -> ValidationResult {
        if (data.count < minLength || data.count > maxLength) {
            return ValidationResult.error(errorCode: code, errorMessage: message)
        }

        return .VALID
    }
}
