//
//  SdkCore.swift
//  SdkCore
//
// 
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
    
    /// Token generation method for a new card.
    ///
    /// - Parameters:
    ///     -  params: a new card information.
    ///     -  timestamp: the timestamp used in the generated token.
    ///     -  registeredFrom: source of token generation.
    ///
    /// - Returns: generated token or error.
    public func generateWithCard(params: CardParams,
                                 timestamp: TimeInterval = Date().timeIntervalSince1970,
                                 registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> TokenResult {

        Logger.shared.log(
            classMethod: type(of: self),
            tag: Logger.TAG,
            message: "generateWithCard(\(params), \(timestamp)): Token generation method for a new card.",
            exception: nil
        )
        
        let validatorsMap: [String?: BaseValidator] = [
            params.cardholder: cardHolderValidator,
            params.mdOrder: orderNumberValidator,
            params.expiryMMYY: cardExpiryValidator,
            params.pan: cardNumberValidator,
            params.cvc: cardCodeValidator,
            params.pubKey: pubKeyValidator
        ]
        
        let fieldErrors: [String?: ParamField] = [
            params.cardholder: .CARDHOLDER,
            params.mdOrder: .MD_ORDER,
            params.expiryMMYY: .EXPIRY,
            params.pan: .PAN,
            params.cvc: .CVC,
            params.pubKey: .PUB_KEY
        ]
        
        for (fieldValue, validator) in validatorsMap {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Logger.TAG,
                message: "generateWithCard(\(params), \(timestamp)): Validate \(fieldErrors[fieldValue])",
                exception: fieldErrors[fieldValue] ?? .UNKNOWN
            )
            
            if let fieldValue {
                let result = validator.validate(data: fieldValue)
                if !result.isValid {
                    let errorField = fieldErrors[fieldValue] ?? .UNKNOWN
                    
                    Logger.shared.log(
                        classMethod: type(of: self),
                        tag: Logger.TAG,
                        message: "generateWithCard(\(params), \(timestamp)): Error \(errorField)",
                        exception: errorField
                    )
                    
                    return TokenResult(errors: [errorField: result.errorCode!])
                }
            }
        }
        
        do {
            let cardInfo = CoreCardInfo(
                identifier: .cardPanIdentifier(params.pan),
                expDate: try params.expiryMMYY.toExpDate(), cvv: params.cvc
            )
            return prepareToken(
                mdOrder: params.mdOrder,
                cardInfo: cardInfo,
                pubKey: params.pubKey,
                timestamp: timestamp,
                registeredFrom: registeredFrom
            )
        } catch let error {
            let errorDescription = (error as NSError).localizedDescription
            return TokenResult(errors: [ParamField.UNKNOWN : errorDescription])
        }
    }
    
    /// Token generation method for a new card.
    ///
    /// - Parameters:
    ///     - params: a new card information.
    ///     - timestamp: the timestamp used in the generated token.
    ///     - registeredFrom: source of token generation.
    /// - Returns: generated token or error.
    public func generateInstanceWithCard(params: CardParams,
                                         timestamp: TimeInterval = Date().timeIntervalSince1970,
                                         registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> TokenResult {
        
        let validatorsMap: [String?: BaseValidator] = [
            params.cardholder: cardHolderValidator,
            params.expiryMMYY: cardExpiryValidator,
            params.pan: cardNumberValidator,
            params.cvc: cardCodeValidator,
            params.pubKey: pubKeyValidator
        ]
        
        let fieldErrors: [String?: ParamField] = [
            params.cardholder: .CARDHOLDER,
            params.expiryMMYY: .EXPIRY,
            params.pan: .PAN,
            params.cvc: .CVC,
            params.pubKey: .PUB_KEY
        ]
        
        for (fieldValue, validator) in validatorsMap {
            if let fieldValue {
                let result = validator.validate(data: fieldValue)
                if !result.isValid {
                    let errorField = fieldErrors[fieldValue] ?? .UNKNOWN
                    return TokenResult(errors: [errorField: result.errorCode!])
                }
            }
        }
        
        do {
            let cardInfo = CoreCardInfo(
                identifier: .cardPanIdentifier(params.pan),
                expDate: try params.expiryMMYY.toExpDate(), 
                cvv: params.cvc,
                cardHolder: params.cardholder
            )

            return prepareToken(
                mdOrder: params.mdOrder,
                cardInfo: cardInfo,
                pubKey: params.pubKey,
                timestamp: timestamp,
                registeredFrom: registeredFrom
            )
        } catch let error {
            print("An error occurred: \(error)")
            let errorDescription = (error as NSError).localizedDescription
            return TokenResult(errors: [ParamField.UNKNOWN : errorDescription])
        }
    }
    
    /// Token generation method for a saved card.
    ///
    /// - Parameters:
    ///     - params: information about the linked card.
    ///     - timestamp: the timestamp used in the generated token.
    ///     - registeredFrom: source of token generation.
    /// - Returns: generated token or error.
    public func generateWithBinding(params: BindingParams,
                                    timestamp: TimeInterval = Date().timeIntervalSince1970,
                                    registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> TokenResult {
        
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Logger.TAG,
            message: "generateWithBinding(\(params), \(timestamp)): Token generation method for a saved card.",
            exception: nil
        )
        
        let validatorsMap: [String?: BaseValidator] = [
            params.mdOrder: orderNumberValidator,
            params.bindingId: cardBindingIdValidator,
            params.cvc: cardCodeValidator,
            params.pubKey: pubKeyValidator
        ]
        
        let fieldErrors: [String?: ParamField] = [
            params.mdOrder: .MD_ORDER,
            params.bindingId: .BINDING_ID,
            params.cvc: .CVC,
            params.pubKey: .PUB_KEY
        ]
        
        for (fieldValue, validator) in validatorsMap {
            if let fieldValue {
                let result = validator.validate(data: fieldValue)
                if !result.isValid {
                    let errorField = fieldErrors[fieldValue] ?? .UNKNOWN
                    
                    Logger.shared.log(
                        classMethod: type(of: self),
                        tag: Logger.TAG,
                        message: "generateWithBinding(\(params), \(timestamp)): Error \(errorField)",
                        exception: ParamField.UNKNOWN
                    )
                    
                    return TokenResult(errors: [errorField: result.errorCode!])
                }
            }
        }
        
        let cardInfo = CoreCardInfo(
            identifier: .cardBindingIdIdentifier(params.bindingId),
            cvv: params.cvc,
            cardHolder: nil
        )
        return prepareToken(mdOrder: params.mdOrder,
                            cardInfo: cardInfo,
                            pubKey: params.pubKey,
                            timestamp: timestamp,
                            registeredFrom: registeredFrom)
    }
    
    /// Token generation method for a saved card.
    ///
    /// - Parameters:
    ///     - params: information about the linked card.
    ///     - timestamp: the timestamp used in the generated token.
    ///     - registeredFrom: source of token generation.
    /// - Returns: generated token or error.
    public func generateInstanceWithBinding(params: BindingParams,
                                            timestamp: TimeInterval = Date().timeIntervalSince1970,
                                            registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> TokenResult {
        
        let validatorsMap: [String?: BaseValidator] = [
            params.bindingId: cardBindingIdValidator,
            params.cvc: cardCodeValidator,
            params.pubKey: pubKeyValidator
        ]
        
        let fieldErrors: [String?: ParamField] = [
            params.bindingId: .BINDING_ID,
            params.cvc: .CVC,
            params.pubKey: .PUB_KEY
        ]
        
        for (fieldValue, validator) in validatorsMap {
            if let fieldValue {
                let result = validator.validate(data: fieldValue)
                if !result.isValid {
                    let errorField = fieldErrors[fieldValue] ?? .UNKNOWN
                    return TokenResult(errors: [errorField: result.errorCode!])
                }
            }
        }
        
        let cardInfo = CoreCardInfo(
            identifier: .cardBindingIdIdentifier(params.bindingId),
            cvv: params.cvc,
            cardHolder: nil
        )
        return prepareToken(mdOrder: params.mdOrder,
                            cardInfo: cardInfo,
                            pubKey: params.pubKey,
                            timestamp: timestamp,
                            registeredFrom: registeredFrom)
    }
    
    public func prepareToken(mdOrder: String = "",
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
    public static func getSDKVersion() -> String { "3.0.0" }
}
