//
//  PaymentConfigBuilder.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

/// Constructor for the formation of the configuration of the payment.
///
/// - Parameters:
///     - order: identifier of the paid order.
public final class PaymentConfigBuilder {
    
    private var order = ""
    private var buttonText: String?
    private var cards = Set<Card>()
    private var cardSaveOptions: CardSaveOptions = .hide
    private var holderInputOptions: HolderInputOptions = .hide
    private var cameraScannerOptions: CameraScannerOptions = .enabled
    private var theme: Theme = .light
    private var uuid: String = UUID().uuidString
    private var timestamp = Int64(Date().timeIntervalSince1970)
    private var locale: Locales = .en
    private var storedPaymentMethodCVCRequired = true
    private var cardDeleteOptions: CardDeleteOptions = .noDelete
    private var displayApplePay = false
    private var registeredFrom: MSDKRegisteredFrom = MSDKRegisteredFrom.MSDK_FORMS
    private var editingBindingsIsEnabled = false
    
    public init(order: String = "") {
        self.order = order
    }
    
    ///Change the text of the payment button.
    ///
    ///Optional, by default localized translation "Pay"
    ///
    /// - Parameters:
    ///     - buttonText: the text of the payment button.
    /// - Returns: the current constructor.
    public func buttonText(buttonText: String) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "buttonText \(buttonText): Change the text of the payment button.",
            exception: nil
        )
        self.buttonText = buttonText
        
        return self
    }

    /// Adding a list of linked cards.
    ///
    /// Optional, default empty list.
    ///
    /// - Parameters:
    ///     - cards: list of related cards.
    /// - Returns: the current constructor.
    public func cards(cards: Set<Card>) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cards \(cards): Adding a list of linked cards.",
            exception: nil
        )
        self.cards = cards

        return self
    }

    /// Option to manage the ability to bind a new card.
    ///
    /// Optional, default HIDE
    ///
    /// - Parameters:
    ///     - options: setting the function of binding a new card.
    /// - Returns: the current constructor.
    public func cardSaveOptions(options: CardSaveOptions) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cardSaveOptions \(options): Option to manage the ability to bind a new card.",
            exception: nil
        )
        self.cardSaveOptions = options
        
        return self
    }

    /// Option to control the functionality of scanning the card through the camera.
    ///
    /// Optional, default ENABLED
    ///
    /// - Parameters:
    ///     - options: setting of the card scanning function.
    /// - Returns: the current constructor.
    public func cameraScannerOptions(options: CameraScannerOptions) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cameraScannerOptions \(options):",
            exception: nil
        )
        self.cameraScannerOptions = options
        
        return self
    }

    ///Option to control the theme of the interface.
    ///
    ///Optional, default SYSTEM.
    ///
    /// - Parameters:
    ///     - theme: setting of the card scanning function.
    ///- Returns: the current constructor.
    public func theme(theme: Theme) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "theme \(theme): Option to control the theme of the interface.",
            exception: nil
        )
        self.theme = theme
        
        return self
    }

    /// Option to control the ability to display the cardholder input field.
    ///
    /// Optional, default HIDE
    ///
    /// - Parameters:
    ///     - options: setting the cardholder input field.
    /// - Returns: the current constructor.
    public func holderInputOptions(options: HolderInputOptions) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "holderInputOptions: \(options)",
            exception: nil
        )
        self.holderInputOptions = options
        
        return self
    }

    /// Setting a unique identifier for the payment.
    ///
    /// Optionally, a unique payment identifier is generated automatically.
    ///
    /// - Parameters:
    ///     - uuid: payment identifier.
    /// - Returns: the current constructor.
    public func uuid(uuid: String) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "uuid \(uuid): Setting a unique identifier for the payment.",
            exception: nil
        )
        self.uuid = uuid
        
        return self
    }

    /// Setting the time of formation of payment.
    ///
    /// Optionally, the time of formation of the payment is set automatically.
    ///
    /// - Parameters:
    ///     - timestamp: time of payment formation.
    /// - Returns: the current constructor.
    public func timestamp(timestamp: Int64) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "timestamp \(timestamp): Setting the time of formation of payment.",
            exception: nil
        )
        self.timestamp = timestamp
        
        return self
    }

    /// Installation of localization.
    ///
    /// Optionally, the localization of the shape of the floor is determined automatically.
    ///
    /// - Parameters_
    ///     - locale: localization.
    /// - Returns: the current constructor.
    public func locale(locale: Locales) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "locale \(locale): Installation of localization.",
            exception: nil
        )
        self.locale = locale
        
        return self
    }

    /// Setting the check for mandatory filling of the CVC field when paying with a linked card.
    ///
    /// Optional, default true.
    ///
    /// - Parameters:
    ///     - required: CVC filling requirement.
    /// - Returns: the current constructor.
    public func storedPaymentMethodCVCRequired(required: Bool) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "storedPaymentMethodCVCRequired: \(required)",
            exception: nil
        )
        self.storedPaymentMethodCVCRequired = required
        
        return self
    }

    /// Option to manage the ability to remove the card.
    ///
    /// Optional, default NO_DELETE
    ///
    /// - Parameters:
    ///     - options: setting the function for deleting the map.
    /// - Returns: the current constructor.
    public func cardDeleteOptions(options: CardDeleteOptions) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cardDeleteOptions \(options): Option to manage the ability to remove the card.",
            exception: nil
        )
        self.cardDeleteOptions = options
        
        return self
    }
    
    /// Option to manage the source.
    ///
    /// Optional, default MSDK_FORMS
    ///
    /// - Parameters:
    /// - registeredFrom setting the source.
    /// - Returns: the current constructor
    public func registeredFrom(registeredFrom: MSDKRegisteredFrom) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "registeredFrom \(registeredFrom): Option to manage the source.",
            exception: nil
        )
        
        self.registeredFrom = registeredFrom
        
        return self
    }
    
    public func displayApplePay(isDisplay: Bool) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "displayApplePay \(isDisplay): Option to manage the ability to remove the card.",
            exception: nil
        )
        self.displayApplePay = isDisplay
        
        return self
    }
    
    /// Option to edit bindings list
    ///
    /// - Parameters:
    ///     - isEnabled: editing list items isEnabled
    /// - Returns: the current contructor
    public func editingBindingsIsEnabled(_ isEnabled: Bool = false) -> PaymentConfigBuilder {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "editingBindingsIsEnabled \(isEnabled): Option to edit bindings list.",
            exception: nil
        )
        self.editingBindingsIsEnabled = isEnabled
        
        return self
    }

    /// Creates a payment configuration.
    ///
    /// - Returns: payment configuration.
    public func build() -> PaymentConfig {
        PaymentConfig(
            order: self.order,
            cardSaveOptions: self.cardSaveOptions,
            holderInputOptions: self.holderInputOptions,
            cameraScannerOptions: self.cameraScannerOptions,
            theme: self.theme,
            cards: self.cards,
            uuid: self.uuid,
            timestamp: self.timestamp,
            locale: self.locale,
            buttonText: self.buttonText,
            storedPaymentMethodCVCRequired: self.storedPaymentMethodCVCRequired,
            cardDeleteOptions: self.cardDeleteOptions,
            displayApplePay: self.displayApplePay,
            registeredFrom: self.registeredFrom,
            editingBindingsIsEnabled: self.editingBindingsIsEnabled
        )
    }
}
