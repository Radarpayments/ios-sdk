//
//  PaymentController.swift
//  SDKPayment
//
// 
//

import UIKit
import SDKCore
import SDKForms

final class PaymentController {
    
    private let DEFAULT_VALUE_CARDHOLDER: String = "CARDHOLDER"

    private let paymentId: PaymentIdType
    private let checkoutConfig: CheckoutConfig
    private let sdkPaymentConfig: SDKPaymentConfig
    private var parentController: UINavigationController
    private var callbackHandler: any ResultPaymentCallback<PaymentResult>
    private let paymentQueue = DispatchQueue(label: "paymentQueue", attributes: .concurrent)
    
    private lazy var cardFormDelegate: CardFormDelegate = {
        CardFormDelegateImpl(
            parentController: parentController,
            resultCryptogramCallback: self,
            removeCardHandler: deleteBindingCard
        )
    }()
    
    private lazy var threeDS2WebFormDelegate: ThreeDS2WebFormDelegate = {
        ThreeDS2WebFormDelegateImpl(
            parentController: parentController,
            viewControllerDelegate: self
        )
    }()

    private lazy var threeDS2SDKFormDelegate: ThreeDS2SDKFormDelegate = {
        ThreeDS2SDKFormDelegateImpl(
            parentController: parentController,
            viewControllerDelegate: self
        )
    }()
    
    private lazy var paymentManager: PaymentManagerImpl = {
        PaymentManagerImpl(
            paymentQueue: paymentQueue,
            cardFormDelegate: cardFormDelegate,
            threeDS2WebFormDelegate: threeDS2WebFormDelegate,
            threeDS2SDKFormDelegate: threeDS2SDKFormDelegate,
            viewControllerDelegate: self
        )
    }()
    
    init(
        checkoutConfig: CheckoutConfig,
        sdkPaymentConfig: SDKPaymentConfig,
        parentController: UINavigationController,
        callbackHandler: any ResultPaymentCallback<PaymentResult>
    ) {
        self.paymentId = checkoutConfig.id
        self.checkoutConfig = checkoutConfig
        self.sdkPaymentConfig = sdkPaymentConfig
        self.parentController = parentController
        self.callbackHandler = callbackHandler
    }
    
    func startPaymentFlow() throws {
        do {
            try paymentManager.checkout(config: checkoutConfig)
        } catch {
            throw error
        }
    }
    
    private func paymentNewCard(
        paymentToken: String?,
        paymentInfo: PaymentInfoNewCard,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        guard let paymentToken else {
            completion(SDKCryptogramException(message: "Payment token is nil"))
            return
        }

        paymentQueue.async { [weak self] in
            guard let self else { return }
            let cardHolder = paymentInfo.holder.isEmpty 
                ? DEFAULT_VALUE_CARDHOLDER
                : paymentInfo.holder
            
            do {
                let fullPayerData = fullPayerData(from: paymentInfo.mandatoryFieldsValues)

                try paymentManager.processFormData(
                    cryptogramApiData: CryptogramApiData(
                        paymentToken: paymentToken,
                        mdOrder: paymentInfo.order,
                        holder: cardHolder,
                        saveCard: paymentInfo.saveCard,
                        fullPayerData: fullPayerData
                    ),
                    isBinding: false
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func paymentBindingCard(
        paymentToken: String?,
        paymentInfo: PaymentInfoBindCard,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        guard let paymentToken else {
            completion(SDKCryptogramException(message: "Payment token is nil"))
            return
        }
        
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                let fullPayerData = fullPayerData(from: paymentInfo.mandatoryFieldsValues)
                
                try paymentManager.processFormData(
                    cryptogramApiData: CryptogramApiData(
                        paymentToken: paymentToken,
                        mdOrder: paymentInfo.order,
                        holder: DEFAULT_VALUE_CARDHOLDER,
                        fullPayerData: fullPayerData
                    ),
                    isBinding: true
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func paymentApplePay(
        paymentInfo: PaymentInfoApplePay,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                try paymentManager.processApplePay(
                    cryptogramApplePayApiData: CryptogramApplePayApiData(
                        mdOrder: paymentInfo.order,
                        paymentToken: paymentInfo.paymentToken
                    )
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func deleteBindingCard(_ bindingId: String) {
        paymentQueue.async {
            let success = self.paymentManager.unbindCard(bindingId: bindingId)
            
            if !success {
                LogDebug.shared.logIfDebug(message: "Error unbind card")
            }
        }
    }
    
    private func fullPayerData(from fieldsValues: [String: String]) -> FullPayerData {
        var fullPayerData = FullPayerData()
        
        fieldsValues.forEach { key, value in
            if let billingpayerDataField = BillingPayerDataFields(stringValue: key) {
                switch billingpayerDataField {
                case .MOBILE_PHONE:          fullPayerData.mobilePhone = value
                case .EMAIL:                 fullPayerData.email = value
                case .BILLING_COUNTRY:       fullPayerData.billingPayerData.billingCountry = value
                case .BILLING_STATE:         fullPayerData.billingPayerData.billingState = value
                case .BILLING_POSTAL_CODE:   fullPayerData.billingPayerData.billingPostalCode = value
                case .BILLING_CITY:          fullPayerData.billingPayerData.billingCity = value
                case .BILLING_ADDRESS_LINE1: fullPayerData.billingPayerData.billingAddressLine1 = value
                case .BILLING_ADDRESS_LINE2: fullPayerData.billingPayerData.billingAddressLine2 = value
                case .BILLING_ADDRESS_LINE3: fullPayerData.billingPayerData.billingAddressLine3 = value
                }
            }
        }
        
        return fullPayerData
    }
}

extension PaymentController: ViewControllerDelegate {

    func finishWithResult(paymentData: PaymentResultData) {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let topViewController = UIApplication.shared.topViewController
            else { return }
            
            switch topViewController {
            case let topViewController as UINavigationController:
                if popLastIfNeed(navigationController: topViewController) {
                    finishWithResult(paymentData: paymentData)
                    return
                }
                
                let idForResult: String
                
                switch paymentId {
                case let .sessionId(id),
                     let .mdOrder(id):
                    idForResult = id
                }
                
                let paymentResult = PaymentResult(paymentId: idForResult,
                                                  paymentResultData: paymentData)
                
                callbackHandler.onResult(result: paymentResult)
            
            case let topViewController as ViewController3DS2WebChallenge:
                topViewController.dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    
                    self.finishWithResult(paymentData: paymentData)
                }
                
            case let topViewController as PaymentBottomSheetViewController:
                topViewController.dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    
                    self.finishWithResult(paymentData: paymentData)
                }

            default:
                let clearId: String
                
                switch paymentId {
                case let .sessionId(id),
                     let .mdOrder(id):
                    clearId = id
                }
                
                let paymentResult = PaymentResult(paymentId: clearId,
                                                  paymentResultData: paymentData)
                callbackHandler.onResult(result: paymentResult)
            }
        }
    }
    
    func getPaymentConfig() -> SDKPaymentConfig { try! SdkPayment.shared.sdkPaymnetConfig() }
    
    @discardableResult
    private func popLastIfNeed(navigationController: UINavigationController) -> Bool {
        switch navigationController.viewControllers.last {
        case _ as NewCardViewController,
             _ as SelectedCardViewController,
             _ as CardListViewController:
            
            navigationController.popViewController(animated: true)
            return true
        default:
            return false
        }
    }
}


extension PaymentController: ResultCryptogramCallback {

    func onSuccess(result: CryptogramData) {
        popLastIfNeed(navigationController: parentController)

        switch result.status {
        case .succeeded:
            let info = result.info
            
            switch info {
            case let info as PaymentInfoNewCard:
                do {
                    let keyProvider = RemoteKeyProvider(url: sdkPaymentConfig.keyProviderUrl)
                    let pubKey = try keyProvider.provideKey().value

                    let sdkCoreConfig = SDKCoreConfig(
                        paymentMethodParams: .cardParams(
                            params: CardParams(
                                pan: info.pan,
                                cvc: info.cvc,
                                expiryMMYY: info.expiry,
                                cardholder: info.holder.isEmpty ? DEFAULT_VALUE_CARDHOLDER : info.holder,
                                mdOrder: info.order,
                                pubKey: pubKey
                            )
                        ),
                        registeredFrom: .MSDK_PAYMENT
                    )
                    
                    let sdkCore = SdkCore()
                    let paymentToken = sdkCore.generateWithConfig(config: sdkCoreConfig).token
                    
                    paymentNewCard(paymentToken: paymentToken, paymentInfo: info) { [weak self] error in
                        guard let self else { return }
                        
                        let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                        finishWithResult(paymentData: paymentResultData)
                    }
                } catch {
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error as? SDKException)
                    finishWithResult(paymentData: paymentResultData)
                }

            case let info as PaymentInfoBindCard:
                do {
                    let keyProvider = RemoteKeyProvider(url: sdkPaymentConfig.keyProviderUrl)
                    let pubKey = try keyProvider.provideKey().value
                    
                    let sdkCoreConfig = SDKCoreConfig(
                        paymentMethodParams: .bindingParams(
                            params: BindingParams(
                                pubKey: pubKey,
                                bindingId: info.bindingId,
                                cvc: info.cvc,
                                mdOrder: info.order
                            )
                        )
                    )
                    
                    let sdkCore = SdkCore()
                    let paymentToken = sdkCore.generateWithConfig(config: sdkCoreConfig).token
                    
                    paymentBindingCard(paymentToken: paymentToken, paymentInfo: info) { [weak self] error in
                        guard let self else { return }
                        
                        let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                        finishWithResult(paymentData: paymentResultData)
                    }
                } catch {
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error as? SDKException)
                    finishWithResult(paymentData: paymentResultData)
                }

            case let info as PaymentInfoApplePay:
                paymentApplePay(paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResultData)
                }
            default:
                break
            }
        case .canceled:
            LogDebug.shared.logIfDebug(message: "Cryptogram canceled")
            paymentManager.finishWithError(exception: SDKCryptogramException())
        }
    }
    
    func onFail(error: SDKException) {
        LogDebug.shared.logIfDebug(message: "Cryptogram error: \(error.message) \(error.cause)")
        paymentManager.finishWithError(exception: SDKCryptogramException())
    }
}

private extension UIApplication {
    
    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}
