//
//  BaseValidationRule.swift
//  SDKCore
//
// 
//

import Foundation

/// Protocol for creating data validation rules
protocol BaseValidationRule {
    associatedtype DATA
    
    /// The method is called when validating data [data].
    ///
    /// - Parameters:
    ///     - data: data for checking.
    ///
    /// - Returns: null if the data matches the rule, otherwise the text is paired with the value of the error code and the error text.
    func validateForError(data: DATA) -> ValidationResult
}

struct AnyBaseValidationRule<DATA>: BaseValidationRule {
    private let validateForErrorClosure: (DATA) -> ValidationResult
    
    init<R: BaseValidationRule>(baseRule: R) where R.DATA == DATA {
            validateForErrorClosure = baseRule.validateForError
        }
    
    func validateForError(data: DATA) -> ValidationResult {
        validateForErrorClosure(data)
    }
}
