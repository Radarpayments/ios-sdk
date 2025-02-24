//
//  File.swift
//

import Foundation

/// Country value validator
public final class CountryValidator: BaseValidator<String> {
    
    override public init() {
        super.init()
        
        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .requiredField().localized
                )
            )
        )
    }
}
