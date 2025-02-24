//
//  File.swift
//

import Foundation

/// AddressLine2 value validator
public final class AddressLine2Validator: BaseValidator<String> {
    
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
