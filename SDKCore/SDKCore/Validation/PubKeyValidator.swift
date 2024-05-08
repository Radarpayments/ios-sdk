//
//  PubKeyValidator.swift
//  SDKCore
//
// 
//

import Foundation

/// Validator to check the validity of the public key.
class PubKeyValidator: BaseValidator<String> {
    
    override init() {
        super.init()

        addRules(
            AnyBaseValidationRule(
                baseRule: StringRequiredRule(
                    code: ValidationCodes.required,
                    message: .pubKeyRequired().localized
                )
            )
        )
    }
}
