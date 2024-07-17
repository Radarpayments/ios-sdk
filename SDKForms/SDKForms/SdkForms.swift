//
//  SDKForms.swift
//
//
// 
//

import UIKit
import SDKCore
import PassKit

/// The main class for working with the functionality of the user interface library from a mobile application.
public final class SdkForms: NSObject {
    
    public static let shared = SdkForms()
    
    private var innerSDKConfig: SDKConfig?
    private var innerCryptograProcessor: CryptogramProcessor?
    
    private var parent: UINavigationController?
    private var paymentConfig: PaymentConfig?
    private var applePayPaymentConfig: ApplePayPaymentConfig?
    private var callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    
    private var applePayData: Data?
    
    private override init() {
        super.init()
    }
    
    /// Initialization
    public static func initialize(sdkConfig: SDKConfig) -> SdkForms {
        shared.innerSDKConfig = sdkConfig
        shared.innerCryptograProcessor = DefaultCryptogramProcessor(
            keyProvider: sdkConfig.keyProvider,
            paymentStringProcessor: DefaultPaymentStringProcessor(),
            cryptogramCipher: RSACryptogramCipher()
        )

        return shared
    }
    
    /// - Returns: SDKForms version
    func sdkConfig() throws -> SDKConfig {
        if let innerSDKConfig { return innerSDKConfig }

        throw SDKException(message: "Please call SDKForms.initialize(sdkConfig:) before.")
    }
    
    func cryptogramProcessor() throws -> CryptogramProcessor {
        if let innerCryptograProcessor { return innerCryptograProcessor}
        
        throw SDKException(message: "Please call SDKForms.initialize(sdkConfig:) before.")
    }
    
    public static func getSDKVersion() -> String { "3.0.2" }
    
    /// Launching the payment process.
    ///
    /// - Parameters"
    ///     - navigationController: nav vc for push.
    ///     - config: payment configuration.
    public func cryptogram(
        navigationController: UINavigationController,
        config: PaymentConfig,
        callbackHandler: any ResultCryptogramCallback<CryptogramData>
    ) {
        guard let cryptograProcessor = try? cryptogramProcessor() else {
            callbackHandler.onFail(error: SDKException(message: "Please call SDKForms.initialize(sdkConfig:) before."))
            return
        }
        
        LocalizationSetting.shared.setLanguage(locale: config.locale)
        ThemeSetting.shared.setTheme(config.theme)
        
        self.parent = navigationController
        self.paymentConfig = config
        self.callbackHandler = callbackHandler
        
        if config.cards.isEmpty {
            Logger.shared.log(
                classMethod: type(of: self),
                tag: Constants.TAG,
                message: "cryptogram \(config): Launching the payment process from NewCardViewController",
                exception: nil
            )
            
            navigationController.pushViewController(NewCardViewController(paymentConfig: config, callbackHandler: callbackHandler), animated: true)
            return
        }
        
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cryptogram \(config): Launching the payment process from CardListViewController",
            exception: nil
        )
        navigationController.pushViewController(CardListViewController(paymentConfig: config, callbackHandler: callbackHandler), animated: true)
    }
    
    /// Launching the payment process from BottomSheet.
    ///
    /// - Parameters:
    ///     - parent: parent for present
    ///     - config: payment configuration.
    public func cryptogramWithBottomSheet(
        parent: UINavigationController,
        config: PaymentConfig,
        applePayPaymentConfig: ApplePayPaymentConfig?,
        callbackHandler: (any ResultCryptogramCallback<CryptogramData>)
    ) {
        guard let cryptograProcessor = try? cryptogramProcessor() else {
            callbackHandler.onFail(error: SDKException(message: "Please call SDKForms.initialize(sdkConfig:) before."))
            return
        }
        
        LocalizationSetting.shared.setLanguage(locale: config.locale)
        ThemeSetting.shared.setTheme(config.theme)
        
        self.parent = parent
        self.paymentConfig = config
        self.applePayPaymentConfig = applePayPaymentConfig
        self.callbackHandler = callbackHandler

        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "cryptogram \(config): Launching the payment process from NewCardBottomSheet",
            exception: nil
        )
        
        let paymentBottomSheetVC = PaymentBottomSheetViewController(
            paymentConfig: config,
            delegate: self,
            callbackHandler: callbackHandler
        )
        
        DispatchQueue.main.async {
            paymentBottomSheetVC.modalPresentationStyle = .custom
            let transitionDelegate = BottomSheetTransitionDelegate()
            paymentBottomSheetVC.transitioningDelegate = transitionDelegate
            paymentBottomSheetVC.modalTransitionStyle = .coverVertical
            
            
            parent.present(paymentBottomSheetVC, animated: true)
        }
    }
}

extension SdkForms: PaymentBottomSheetDelegate {

    func selectCard(_ card: Card) {
        let selectedCardVC = SelectedCardViewController(
            paymentConfig: paymentConfig,
            card: card,
            callbackHandler: callbackHandler
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            parent?.pushViewController(
                selectedCardVC,
                animated: true
            )
        }
    }
    
    func selectAddNewCard() {
        let newCardVC = NewCardViewController(
            paymentConfig: paymentConfig,
            callbackHandler: callbackHandler
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            parent?.pushViewController(
                newCardVC,
                animated: true
            )
        }
    }
    
    func selectAllPaymentMethods() {
        let allPaymentsMethodsVC = CardListViewController(
            paymentConfig: paymentConfig,
            callbackHandler: callbackHandler
        )

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            parent?.pushViewController(
                allPaymentsMethodsVC,
                animated: true
            )
        }
    }
    
    func onClickApplePay() {
        guard let applePayPaymentConfig else { return }
        
        let pkRequest = createPKPaymentRequest(withConfig: applePayPaymentConfig)
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: pkRequest)
        controller?.delegate = self

        if let controller {
            parent?.present(controller, animated: true)
        }
    }
    
    private func createPKPaymentRequest(withConfig config: ApplePayPaymentConfig) -> PKPaymentRequest {
        let pkRequest = PKPaymentRequest()
        pkRequest.merchantIdentifier = config.merchantId
        pkRequest.currencyCode = config.currencyCode
        pkRequest.supportedNetworks = config.supportedNetworks
        pkRequest.countryCode = config.countryCode
        pkRequest.paymentSummaryItems = config.items.map {
            PKPaymentSummaryItem(label: $0.label, amount: NSDecimalNumber(value: $0.amount))
        }
        pkRequest.merchantCapabilities = .threeDSecure
        
        return pkRequest
    }
    
    private func paymentTokenString(_ data: Data) -> String? {
        let dict = try? JSONSerialization.jsonObject(with: data)
        let jsonData = try? JSONSerialization.data(withJSONObject: dict)

        return jsonData?.base64EncodedString()
    }
}

extension SdkForms: PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        guard let applePayData,
              let paymentToken = paymentTokenString(applePayData),
              let order = paymentConfig?.order
        else {
            controller.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                
                callbackHandler?.onFail(error: SDKException())
            }
            return
        }

        let applePayPaymentInfo = PaymentInfoApplePay(order: order)
        let cryptogramData = CryptogramData(status: .succeeded, 
                                            paymentToken: paymentToken,
                                            info: applePayPaymentInfo,
                                            deletedCardList: [])
        
        controller.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            callbackHandler?.onSuccess(result: cryptogramData)
        }
    }
    
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, 
                                                   didAuthorizePayment payment: PKPayment,
                                                   handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if let dict = try? JSONSerialization.jsonObject(with: payment.token.paymentData) {
            applePayData = payment.token.paymentData
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            return
        }
        
        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
    }
}
