//
//  FormValidator.swift
//  MyStore
//

import SDKCore
import Foundation

struct FormValidationResult {
    var cardNumber: SDKCore.ValidationResult = .VALID
    var cardExpiry: SDKCore.ValidationResult = .VALID
    var cardCode: SDKCore.ValidationResult = .VALID
    var cardHolder: SDKCore.ValidationResult = .VALID
    var isValid: Bool = true
}

class FormValidator {
    private let cardNumberValidator = CardNumberValidator()
    private let cardExpiryValidator = CardExpiryValidator()
    private let cardCodeValidator = CardCodeValidator()
    private let cardHolderValidator = CardHolderValidator()

    func validate(type: TokenType, formData: TokenFormData) -> FormValidationResult {
        var result = FormValidationResult()

        switch type {
        case .card, .cardInstant, .newPaymentMethod:
            result.cardNumber = cardNumberValidator.validate(data: formData.cardNumber)
            result.cardExpiry = cardExpiryValidator.validate(data: formData.cardExpiry)
            result.cardCode = cardCodeValidator.validate(data: formData.cardCode)

            // Cardholder is optional, only validate if not empty
            if !formData.cardHolder.isEmpty {
                result.cardHolder = cardHolderValidator.validate(data: formData.cardHolder)
            }

            if !isValidationResultValid(result.cardNumber) ||
                !isValidationResultValid(result.cardExpiry) ||
                !isValidationResultValid(result.cardCode) ||
                !isValidationResultValid(result.cardHolder
                ) {
                result.isValid = false
            }

            if type == .card && formData.mdOrder.isEmpty {
                result.isValid = false
            }

        case .binding, .bindingInstant:
            // CVC is optional for these types, only validate if not empty
            if !formData.cardCode.isEmpty {
                result.cardCode = cardCodeValidator.validate(data: formData.cardCode)
            }

            if !isValidationResultValid(result.cardCode) || formData.bindingId.isEmpty {
                result.isValid = false
            }

            if type == .binding && formData.mdOrder.isEmpty {
                result.isValid = false
            }

        case .storedPaymentMethod:
            // CVC is optional for this type, only validate if not empty
            if !formData.cardCode.isEmpty {
                result.cardCode = cardCodeValidator.validate(data: formData.cardCode)
            }

            if !isValidationResultValid(result.cardCode) || formData.storedPaymentMethodId.isEmpty {
                result.isValid = false
            }
        }

        if formData.publicKey.isEmpty {
            result.isValid = false
        }

        return result
    }

    func validateCardNumber(_ text: String) -> SDKCore.ValidationResult {
        return cardNumberValidator.validate(data: text)
    }

    func validateCardExpiry(_ text: String) -> SDKCore.ValidationResult {
        return cardExpiryValidator.validate(data: text)
    }

    func validateCardCode(_ text: String) -> SDKCore.ValidationResult {
        return cardCodeValidator.validate(data: text)
    }

    func validateCardHolder(_ text: String) -> SDKCore.ValidationResult {
        return cardHolderValidator.validate(data: text)
    }
}
