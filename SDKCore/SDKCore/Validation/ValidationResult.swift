//
//  ValidationResult.swift
//  SDKCore
//
// 
//

import Foundation

/// Description of the data validation result.
///
/// - Parameters:
///     - isValid: true the data is correct, otherwise false.
///     - errorCode: error code, does not change during String.
///     - errorMessage: error message in the data, if it was detected during validation.
public struct ValidationResult {

    public let isValid: Bool
    public let errorCode: String?
    public let errorMessage: String?
    
    public static var VALID = ValidationResult(
        isValid: true,
        errorCode: nil,
        errorMessage: nil
    )
    
    /// Method describing the error .
    ///
    /// - Parameters:
    ///     - errorCode: error code.
    ///     - errorMessage: message displayed in case of incorrect value of the card parameter.
    ///
    ///     - Returns: validation result.
    public static func error(
        errorCode: String,
        errorMessage: String
    ) -> ValidationResult {
        ValidationResult(
            isValid: false,
            errorCode: errorCode,
            errorMessage: errorMessage
        )
    }
}
