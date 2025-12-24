//
//  ValidationHelpers.swift
//  MyStore
//

import SDKCore

// Helper function to check if ValidationResult is valid
// ValidationResult doesn't conform to Equatable, so we use string comparison
func isValidationResultValid(_ result: ValidationResult) -> Bool {
    return String(describing: result) == String(describing: ValidationResult.VALID)
}

enum SimpleValidationState {
    case valid
    case invalid
    case empty
}
