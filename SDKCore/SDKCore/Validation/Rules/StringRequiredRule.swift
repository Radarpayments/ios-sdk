//
//  StringRequiredRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Rule for checking a field for empty value.
///
/// - Parameters:
///     - code: error code.
///     - message: message displayed when a numeric value is out of range.
class StringRequiredRule: BaseValidationRule {
    
    typealias DATA = String
    
    private var code: String
    private var message: String
    
    init(
        code: String,
        message: String
    ) {
        self.code = code
        self.message = message
    }
    
    func validateForError(data: String) -> ValidationResult {        
        if data.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return ValidationResult.error(
                errorCode: code,
                errorMessage: message
            )
        }

        return .VALID
    }
}
