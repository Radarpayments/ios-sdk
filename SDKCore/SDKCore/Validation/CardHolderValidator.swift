//
//  CardHolderValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Cardholder name value validator.
public class CardHolderValidator: BaseValidator<String> {

    private let MAX_LENGTH = 30
    private let PATTERN = "^[a-zA-Z ]+$"
    
    override public init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .cardIncorrectCardHolder().localized
                )
            ),
            AnyBaseValidationRule(
                baseRule:
                    StringLengthRule(
                        code: ValidationCodes.invalid,
                        message: .cardIncorrectCardHolder().localized,
                        maxLength: MAX_LENGTH
                    )
            ),
            AnyBaseValidationRule(
                baseRule: RegExRule(
                    code: ValidationCodes.invalidFormat,
                    message: .cardIncorrectCardHolder().localized,
                    regex: PATTERN.toRegex()
                )
            )
        )
    }
}
