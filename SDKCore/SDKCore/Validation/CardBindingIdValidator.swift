//
//  CardBindingIdValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Bind ID value validator.
class CardBindingIdValidator: BaseValidator<String> {

    private let PATTERN = "^\\S+$"

    override init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule:
                    StringRequiredRule(
                        code: ValidationCodes.required,
                        message: .bindingRequired().localized
                    )
            ),
            AnyBaseValidationRule(
                baseRule: RegExRule(
                    code: ValidationCodes.invalid,
                    message: .bindingIncorrect().localized,
                    regex: PATTERN.toRegex()
                )
            )
        )
    }
}
