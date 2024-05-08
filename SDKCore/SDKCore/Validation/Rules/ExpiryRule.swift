//
//  ExpiryRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule for checking the right of the card expiration format.
///
/// - Parameters:
///     - code: error code.
///     - message: message displayed in case of incorrect value of the card validity period.
class ExpiryRule: BaseValidationRule {

    typealias DATA = String

    private var code: String
    private var message: String
    private let monthChecker: IntRangeRule
    private let yearChecker: IntRangeRule
    
    private let MONTH_MIN = 1
    private let MONTH_MAX = 12
    private let INVALID_FIELD_VALUE = -1
    private let YEAR_MIN = 0
    private let YEAR_MAX = 99

    init(code: String, message: String) {
        self.code = code
        self.message = message
        
        self.monthChecker = IntRangeRule(
            code: code,
            message: self.message,
            min: MONTH_MIN, max: MONTH_MAX
        )
        
        self.yearChecker = IntRangeRule(
            code: code,
            message: message,
            min: YEAR_MIN,
            max: YEAR_MAX
        )
    }

    func validateForError(data: String) -> ValidationResult {
        let digits = data.digitsOnly()
        
        let month = digits.take(2).toIntOrNil() ?? INVALID_FIELD_VALUE
        let year = digits.takeLast(2).toIntOrNil() ?? INVALID_FIELD_VALUE

        let monthValidationResult = monthChecker.validateForError(data: month)
        let yearValidationResult = yearChecker.validateForError(data: year)

        if !monthValidationResult.isValid {
            return monthValidationResult
        } 
        
        if !yearValidationResult.isValid {
            return yearValidationResult
        }

        return .VALID
    }
}
