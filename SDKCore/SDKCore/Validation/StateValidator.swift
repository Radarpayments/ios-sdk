//
//  File.swift
//

import Foundation

/// State value validator
public final class StateValidator: BaseValidator<String> {
    
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
