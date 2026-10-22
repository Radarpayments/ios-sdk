//
//  TokenGenerationService.swift
//  MyStore
//

import SDKCore
import Foundation

struct TokenFormData {
    var cardNumber: String = ""
    var cardExpiry: String = ""
    var cardCode: String = ""
    var cardHolder: String = ""
    var storedPaymentMethodId: String = ""
    var mdOrder: String = ""
    var bindingId: String = ""
    var publicKey: String = ""
}

class TokenGenerationService {
    private let sdkCore = SdkCore()

    func generateToken(type: TokenType, formData: TokenFormData) -> TokenResult {
        switch type {
        case .card:
            return generateTokenForCard(formData: formData)
        case .cardInstant:
            return generateTokenForCardInstant(formData: formData)
        case .binding:
            return generateTokenForBinding(formData: formData)
        case .bindingInstant:
            return generateTokenForBindingInstant(formData: formData)
        case .newPaymentMethod:
            return generateTokenForNewPaymentMethod(formData: formData)
        case .storedPaymentMethod:
            return generateTokenForStoredPaymentMethod(formData: formData)
        }
    }

    private func generateTokenForCard(formData: TokenFormData) -> TokenResult {
        let params = CardParams(
            pan: formData.cardNumber,
            cvc: formData.cardCode,
            expiryMMYY: formData.cardExpiry,
            cardholder: formData.cardHolder.isEmpty ? nil : formData.cardHolder,
            mdOrder: formData.mdOrder,
            pubKey: formData.publicKey
        )
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))

        return sdkCore.generateWithConfig(config: config)
    }

    private func generateTokenForCardInstant(formData: TokenFormData) -> TokenResult {
        let params = CardParamsInstant(
            pan: formData.cardNumber,
            cvc: formData.cardCode,
            expiryMMYY: formData.cardExpiry,
            cardholder: formData.cardHolder.isEmpty ? nil : formData.cardHolder,
            pubKey: formData.publicKey
        )
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))

        return sdkCore.generateWithConfig(config: config)
    }

    private func generateTokenForBinding(formData: TokenFormData) -> TokenResult {
        let params = BindingParams(
            pubKey: formData.publicKey,
            bindingId: formData.bindingId,
            cvc: formData.cardCode.isEmpty ? nil : formData.cardCode,
            mdOrder: formData.mdOrder
        )
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))

        return sdkCore.generateWithConfig(config: config)
    }

    private func generateTokenForBindingInstant(formData: TokenFormData) -> TokenResult {
        let params = BindingParamsInstant(
            pubKey: formData.publicKey,
            bindingId: formData.bindingId,
            cvc: formData.cardCode.isEmpty ? nil : formData.cardCode
        )
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))

        return sdkCore.generateWithConfig(config: config)
    }

    private func generateTokenForNewPaymentMethod(formData: TokenFormData) -> TokenResult {
        let params = NewPaymentMethodParams(
            pan: formData.cardNumber,
            cvc: formData.cardCode,
            expiryMMYY: formData.cardExpiry,
            cardholder: formData.cardHolder.isEmpty ? nil : formData.cardHolder,
            pubKey: formData.publicKey
        )
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))

        return sdkCore.generateWithConfig(config: config)
    }

    private func generateTokenForStoredPaymentMethod(formData: TokenFormData) -> TokenResult {
        let params = StoredPaymentMethodParams(
            pubKey: formData.publicKey,
            storedPaymentMethodId: formData.storedPaymentMethodId,
            cvc: formData.cardCode.isEmpty ? nil : formData.cardCode
        )
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))

        return sdkCore.generateWithConfig(config: config)
    }
}
