//
//  File.swift
//

import Foundation

/// Phone number value validator
public final class PhoneNumberValidator: BaseValidator<String> {
    
    private let PATTERN = "^\\+?[0-9]+$"
    
    override public init() {
        super.init()
        
        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .requiredField().localized
                )
            ),
            AnyBaseValidationRule(
                baseRule: RegExRule(
                    code: ValidationCodes.invalidFormat,
                    message: .phoneNumberIncorrect().localized,
                    regex: PATTERN.toRegex()
                )
            )
        )
    }
}
