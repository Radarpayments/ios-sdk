//
//  OrderNumberValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Order number value validator.
class OrderNumberValidator: BaseValidator<String> {

    private let MIN_LENGTH = 1
    private let PATTERN = "^\\S+$"
    
    override init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .orderIncorrectLength().localized
                )
            ),
            AnyBaseValidationRule(
                baseRule: StringLengthRule(
                    code: ValidationCodes.invalid,
                    message: .orderIncorrectLength().localized,
                    minLength: MIN_LENGTH
                )
            ),
            AnyBaseValidationRule(
                baseRule: RegExRule(
                    code: ValidationCodes.invalid,
                    message: .orderIncorrectLength().localized,
                    regex: PATTERN.toRegex()
                )
            )
        )
    }
}
