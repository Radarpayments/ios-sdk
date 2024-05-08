//
//  CardNumberValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Card number value validator.
public class CardNumberValidator: BaseValidator<String> {

    private let MIN_LENGTH = 16
    private let MAX_LENGTH = 19
    private let PATTERN = "^[0-9]+$"
    
    override public init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .cardIncorrectNumber().localized
                )
            ),
            AnyBaseValidationRule(
                baseRule: RegExRule(
                    code: ValidationCodes.invalidFormat,
                    message: .cardIncorrectNumber().localized,
                    regex: PATTERN.toRegex()
                )
            ),
            AnyBaseValidationRule(
                baseRule: StringLengthRule(
                    code: ValidationCodes.invalid,
                    message: .cardIncorrectLength().localized,
                    minLength: MIN_LENGTH,
                    maxLength: MAX_LENGTH
                )
            ),
            AnyBaseValidationRule(
                baseRule: LuhnStringRule(
                    code: ValidationCodes.invalid,
                    message: .cardIncorrectNumber().localized
                )
            )
        )
    }
}
