//
//  File.swift
//

import Foundation

/// AddressLine3 value validator
public final class AddressLine3Validator: BaseValidator<String> {
    
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
