//
//  RegExRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule for checking a string value against a regular expression.
///
/// - Parameters:
///     - code: error code.
///     - message: message displayed in case of mismatch of regular expression .
///     - regex: regex to test a string .
class RegExRule: BaseValidationRule {
    
    typealias DATA = String

    private let code: String
    private let message: String
    private let regex: NSRegularExpression

    init(
        code: String,
        message: String,
        regex: NSRegularExpression
    ) {
        self.code = code
        self.message = message
        self.regex = regex
    }

    func validateForError(data: String) -> ValidationResult {
        let range = NSRange(location: 0, length: data.count)

        if regex.matches(in: data, range: range).isEmpty  {
            return ValidationResult.error(
                errorCode: code,
                errorMessage: message
            )
        }
        
        return .VALID
    }
}
