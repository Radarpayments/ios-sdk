//
//  IntRangeRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule to check for a numeric value in a specified range.
///
/// - Parameters:
///     - code: error code.
///     - message: message displayed when a numeric value is out of range.
///     - min: minimum allowable value.
///     - max: maximum allowable value .
class IntRangeRule: BaseValidationRule {

    typealias DATA = Int

    private let code: String
    private let message: String
    private let min: Int
    private let max: Int

    init(
        code: String,
        message: String,
        min: Int = 0,
        max: Int = Int.max
    ) {
        self.code = code
        self.message = message
        self.min = min
        self.max = max
    }

    func validateForError(data: Int) -> ValidationResult {
        if data < min || data > max {
            return ValidationResult.error(
                errorCode: code,
                errorMessage: message
            )
        }
        return .VALID
    }
}
