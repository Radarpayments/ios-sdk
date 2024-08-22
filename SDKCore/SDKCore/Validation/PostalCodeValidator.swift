//
//  File.swift
//

import Foundation

/// Postal code value validator
public final class PostalCodeValidator: BaseValidator<String> {
    
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
