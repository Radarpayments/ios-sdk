//
//  SdkCore.swift
//  SdkCore
//

import Foundation

public class SdkCore {
    
    private let paymentStringProcessor = DefaultPaymentStringProcessor()
    private let cryptogramCipher = RSACryptogramCipher()
    private let orderNumberValidator = OrderNumberValidator()
    private let cardExpiryValidator = CardExpiryValidator()
    private let cardNumberValidator = CardNumberValidator()
    private let cardBindingIdValidator = CardBindingIdValidator()
    private let cardCodeValidator = CardCodeValidator()
    private let cardHolderValidator = CardHolderValidator()
    private let pubKeyValidator = PubKeyValidator()
    
    public init() {}
    
    /// Token generation method for SDKCoreConfig.
    ///
    /// - Parameters:
    ///     -  config: config for generating token.
    ///
    /// - Returns: generated token or error.
    public func generateWithConfig(config: SDKCoreConfig) -> TokenResult {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Logger.TAG,
            message: "generateWithConfig(\(config)): Token generation method for a new card.",
            exception: nil
        )
        
        let validatorsMap = prepareValidatorsMap(for: config.paymentMethodParams)
        let fieldErrors = prepareFieldErrors(for: config.paymentMethodParams)
        
        if let errorTokenResult = validateFields(validatorsMap: validatorsMap,
                                                 fieldErrors: fieldErrors) {
            return errorTokenResult
        }
        
        do {
            let cardInfo = try prepareCoreCardInfo(for: config.paymentMethodParams)
            let mdOrder = prepareMdOrder(for: config.paymentMethodParams)
            let pubKey = preparePubKey(for: config.paymentMethodParams)
            
            return prepareToken(mdOrder: mdOrder,
                                cardInfo: cardInfo,
                                pubKey: pubKey,
                                timestamp: config.timestamp,
                                registeredFrom: config.registeredFrom)
            
            
        } catch {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Logger.TAG,
                message: "generateWithConfig(\(config)): Error \(error.localizedDescription)",
                exception: error
            )
            
            let errorDescription = (error as NSError).localizedDescription
            return TokenResult(errors: [ParamField.UNKNOWN : errorDescription])
        }
    }
    
    private func prepareValidatorsMap(for params: PaymentParamsVariant) -> [String?: BaseValidator<String>] {
        switch params {
        case let .cardParams(params):
            return [ params.cardholder: cardHolderValidator,
                     params.mdOrder: orderNumberValidator,
                     params.expiryMMYY: cardExpiryValidator,
                     params.pan: cardNumberValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]

        case let .cardParamsInstant(params):
            return [ params.cardholder: cardHolderValidator,
                     params.expiryMMYY: cardExpiryValidator,
                     params.pan: cardNumberValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]
            
        case let .bindingParams(params):
            return [ params.mdOrder: orderNumberValidator,
                     params.bindingId: cardBindingIdValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]

        case let .bindingParamsInstant(params):
            return [ params.bindingId: cardBindingIdValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]

        case let .newPaymentMethodParams(params):
            return [ params.cardholder: cardHolderValidator,
                     params.expiryMMYY: cardExpiryValidator,
                     params.pan: cardNumberValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]

        case let .storedPaymentMethodParams(params):
            let extractedBindingId = extractBindingId(storedPaymentMethod: params)

            return [ extractedBindingId: cardBindingIdValidator,
                     params.cvc: cardCodeValidator,
                     params.pubKey: pubKeyValidator ]
        }
    }
    
    private func prepareFieldErrors(for params: PaymentParamsVariant) -> [String?: ParamField] {
        switch params {
        case let .cardParams(params):
            return [ params.cardholder: .CARDHOLDER,
                     params.mdOrder: .MD_ORDER,
                     params.expiryMMYY: .EXPIRY,
                     params.pan: .PAN,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]

        case let .cardParamsInstant(params):
            return [ params.cardholder: .CARDHOLDER,
                     params.expiryMMYY: .EXPIRY,
                     params.pan: .PAN,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]

        case let .bindingParams(params):
            return [ params.mdOrder: .MD_ORDER,
                     params.bindingId: .BINDING_ID,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]
            
        case let .bindingParamsInstant(params):
            return [ params.bindingId: .BINDING_ID,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]

        case let .newPaymentMethodParams(params):
            return [ params.cardholder: .CARDHOLDER,
                     params.expiryMMYY: .EXPIRY,
                     params.pan: .PAN,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]

        case let .storedPaymentMethodParams(params):
            let extractedBindingId = extractBindingId(storedPaymentMethod: params)
            
            return [ extractedBindingId: .STORED_PAYMENT_METHOD_ID,
                     params.cvc: .CVC,
                     params.pubKey: .PUB_KEY ]
        }
    }
    
    private func validateFields(validatorsMap: [String?: BaseValidator<String>],
                                fieldErrors: [String?: ParamField]
    ) -> TokenResult? {
        for (fieldValue, validator) in validatorsMap {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Logger.TAG,
                message: "validateField(\(fieldValue)): Validate \(fieldErrors[fieldValue])",
                exception: fieldErrors[fieldValue] ?? .UNKNOWN
            )
            
            if let fieldValue {
                let result = validator.validate(data: fieldValue)
                if !result.isValid {
                    let errorField = fieldErrors[fieldValue] ?? .UNKNOWN
                    
                    Logger.shared.log(
                        classMethod: type(of: self),
                        tag: Logger.TAG,
                        message: "validateField(\(fieldValue)): Error \(errorField)",
                        exception: errorField
                    )
                    
                    return TokenResult(errors: [errorField: result.errorCode!])
                }
            }
        }
        
        return nil
    }
    
    private func extractBindingId(storedPaymentMethod: StoredPaymentMethodParams) -> String {
        BindingUtils().extractValue(from: storedPaymentMethod.storedPaymentMethodId)
    }
    
    private func prepareCoreCardInfo(for params: PaymentParamsVariant) throws -> CoreCardInfo {
        do {
            switch params {
            case let .cardParams(params):
                return CoreCardInfo(
                    identifier: .newPaymentMethodIdentifier(params.pan),
                    expDate: try params.expiryMMYY.toExpDate(),
                    cvv: params.cvc,
                    cardHolder: params.cardholder
                )
            case let .cardParamsInstant(params):
                return CoreCardInfo(
                    identifier: .newPaymentMethodIdentifier(params.pan),
                    expDate: try params.expiryMMYY.toExpDate(),
                    cvv: params.cvc,
                    cardHolder: params.cardholder
                )
            case let .bindingParams(params):
                return CoreCardInfo(
                    identifier: .storedPaymentMethodIdentifier(params.bindingId),
                    cvv: params.cvc,
                    cardHolder: nil
                )
            case let .bindingParamsInstant(params):
                return CoreCardInfo(
                    identifier: .storedPaymentMethodIdentifier(params.bindingId),
                    cvv: params.cvc,
                    cardHolder: nil
                )
            case let .newPaymentMethodParams(params):
                return CoreCardInfo(
                    identifier: .newPaymentMethodIdentifier(params.pan),
                    expDate: try params.expiryMMYY.toExpDate(),
                    cvv: params.cvc,
                    cardHolder: params.cardholder
                )
            case let .storedPaymentMethodParams(params):
                let extractedBindingId = extractBindingId(storedPaymentMethod: params)
                
                return CoreCardInfo(
                    identifier: .storedPaymentMethodIdentifier(extractedBindingId),
                    cvv: params.cvc,
                    cardHolder: nil
                )
            }
        } catch {
            throw error
        }
    }
    
    private func prepareMdOrder(for params: PaymentParamsVariant) -> String {
        switch params {
        case let .cardParams(params): params.mdOrder
        case .cardParamsInstant(_): ""
        case let .bindingParams(params): params.mdOrder
        case .bindingParamsInstant(_): ""
        case .newPaymentMethodParams(_): ""
        case .storedPaymentMethodParams(_): ""
        }
    }
    
    private func preparePubKey(for params: PaymentParamsVariant) -> String {
        switch params {
        case let .cardParams(params): params.pubKey
        case let .cardParamsInstant(params): params.pubKey
        case let .bindingParams(params): params.pubKey
        case let .bindingParamsInstant(params): params.pubKey
        case let .newPaymentMethodParams(params): params.pubKey
        case let .storedPaymentMethodParams(params): params.pubKey
        }
    }
    
    private func prepareToken(mdOrder: String = "",
                              cardInfo: CoreCardInfo,
                              pubKey: String,
                              timestamp: TimeInterval,
                              registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> TokenResult {
        
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Logger.TAG,
            message: "generation method:",
            exception: nil
        )
        
        let paymentString = paymentStringProcessor.createPaymentString(
            order: mdOrder,
            timestamp: Int64(timestamp),
            uuid: UUID().uuidString,
            cardInfo: cardInfo,
            registeredFrom: registeredFrom
        )
        let key = Key(
            value: pubKey,
            protocol: "RSA",
            expiration: Int64.max
        )
        do {
            let token = try cryptogramCipher.encode(data: paymentString, key: key)
            return TokenResult(token: token)
        } catch CryptogramCipherError.keyCreationFailed {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Logger.TAG,
                message: "generation method: Error \(ParamField.PUB_KEY) is invalid",
                exception: ParamField.PUB_KEY
            )
            
            return TokenResult(errors: [ParamField.PUB_KEY: "invalid"])
        } catch {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Logger.TAG,
                message: "generation method: Error \(ParamField.UNKNOWN) is invalid",
                exception: ParamField.UNKNOWN
            )
            
            return TokenResult(errors: [ParamField.UNKNOWN: "unknown"])
        }
    }
    
    /// - Returns: SDKCore version
    public static func getSDKVersion() -> String { "3.0.5" }
}
