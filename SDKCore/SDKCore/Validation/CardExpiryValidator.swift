//
//  CardExpiryValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Card expiration value validator.
public class CardExpiryValidator: BaseValidator<String> {

    private let PATTERN = "^\\d{2}/\\d{2}$"
    
    override public init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule:
                    StringRequiredRule(
                        code: ValidationCodes.required,
                        message: .cardIncorrectExpiry().localized
                    )
            ),
            AnyBaseValidationRule(
                baseRule:
                    RegExRule(
                        code: ValidationCodes.invalidFormat,
                        message: .cardIncorrectExpiry().localized,
                        regex: PATTERN.toRegex()
                    )
            ),
            AnyBaseValidationRule(
                baseRule: ExpiryRule(
                    code: ValidationCodes.invalid,
                    message: .cardIncorrectExpiry().localized
                )
            )
        )
    }
}
