//
//  BaseValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Base class for creating data validators.
public class BaseValidator<DATA> {
    
    typealias Rules = AnyBaseValidationRule<DATA>
    
    private var rules: [Rules] = []
    
    /// Adding validation rules to the validator.
    func addRules(_ checkers: Rules...) {
        rules.append(contentsOf: checkers)
    }
    
    /// Data validation [data] against a list of predefined validation rules.
    /// - Parameters:
    ///     - data: data for checking.
    public func validate(data: DATA) -> ValidationResult {
        for checker in rules {
            let result = checker.validateForError(data: data)
            if !result.isValid {
                return result
            }
        }
        return ValidationResult(isValid: true, errorCode: nil, errorMessage: nil)
    }
}
