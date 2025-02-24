//
//  File.swift
//

import Foundation

/// Email value validator
public final class EmailValidator: BaseValidator<String> {
    
    private let PATTERN = "^[a-zA-z0-9]+([-+.']\\w+)*@[a-z]+([-.][a-z]+)*\\.[a-z]+([-.][a-z]+)*$"
    
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
                    message: .emailIncorrect().localized,
                    regex: PATTERN.toRegex()
                )
            )
        )
    }
}
