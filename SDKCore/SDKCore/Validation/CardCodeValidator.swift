//
//  CardCodeValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Validator of the value of the secret code of the card.
public class CardCodeValidator: BaseValidator<String> {

    private let minLength = 3
    private let maxLength = 3
    private let PATTERN = "^[0-9]+$"
    
    override public init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .cardIncorrectCVC().localized
                )
            ),
            AnyBaseValidationRule(
                baseRule:
                    StringLengthRule(
                        code: ValidationCodes.invalid,
                        message: .cardIncorrectCVC().localized,
                        minLength: minLength,
                        maxLength: maxLength
                    )
            ),
            AnyBaseValidationRule(
                baseRule:
                    RegExRule(
                        code: ValidationCodes.invalid,
                        message: .cardIncorrectCVC().localized,
                        regex: PATTERN.toRegex()
                    )
            )
        )
    }
}
