//
//  PaymentController.swift
//  SDKPayment
//
// 
//

import UIKit
import SDKForms

final class PaymentController {
    
    private let DEFAULT_VALUE_CARDHOLDER: String = "CARDHOLDER"

    private let paymentId: PaymentIdType
    private let checkoutConfig: CheckoutConfig
    private var parentController: UINavigationController
    private var callbackHandler: any ResultPaymentCallback<PaymentResult>
    private let paymentQueue = DispatchQueue(label: "paymentQueue", attributes: .concurrent)
    
    private lazy var cardFormDelegate: CardFormDelegate = {
        CardFormDelegateImpl(
            parentController: parentController,
            resultCryptogramCallback: self
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
        parentController: UINavigationController,
        callbackHandler: any ResultPaymentCallback<PaymentResult>
    ) {
        self.paymentId = checkoutConfig.id
        self.checkoutConfig = checkoutConfig
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
        paymentToken: String,
        paymentInfo: PaymentInfoNewCard,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            let cardHolder = paymentInfo.holder.isEmpty 
                ? DEFAULT_VALUE_CARDHOLDER
                : paymentInfo.holder
            
            do {
                try paymentManager.processFormData(
                    cryptogramApiData: CryptogramApiData(
                        paymentToken: paymentToken,
                        mdOrder: paymentInfo.order,
                        holder: cardHolder,
                        saveCard: paymentInfo.saveCard
                    ),
                    isBinding: false
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func paymentBindingCard(
        paymentToken: String,
        paymentInfo: PaymentInfoBindCard,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                try paymentManager.processFormData(
                    cryptogramApiData: CryptogramApiData(
                        paymentToken: paymentToken,
                        mdOrder: paymentInfo.order,
                        holder: DEFAULT_VALUE_CARDHOLDER
                    ),
                    isBinding: true
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func paymentApplePay(
        paymentToken: String,
        paymentInfo: PaymentInfoApplePay,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                try paymentManager.processApplePay(
                    cryptogramApplePayApiData: CryptogramApplePayApiData(
                        mdOrder: paymentInfo.order,
                        paymentToken: paymentToken
                    )
                )
            } catch {
                completion(error as? SDKException)
            }
        }
    }
    
    private func deleteBindingCards(cards: Set<Card>) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            cards.forEach { card in
                let success = self.paymentManager.unbindCard(bindingId: card.bindingId)
                
                if !success {
                    LogDebug.shared.logIfDebug(message: "Error unbind card")
                }
            }
        }
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
            deleteBindingCards(cards: result.deletedCardList)
            let info = result.info
            
            switch info {
            case let info as PaymentInfoNewCard:
                paymentNewCard(paymentToken: result.paymentToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResultData)
                }
            case let info as PaymentInfoBindCard:
                paymentBindingCard(paymentToken: result.paymentToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResultData)
                }
            case let info as PaymentInfoApplePay:
                paymentApplePay(paymentToken: result.paymentToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResultData = PaymentResultData(isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResultData)
                }
            default:
                break
            }
        case .canceled:
            LogDebug.shared.logIfDebug(message: "Cryptogram canceled")
            deleteBindingCards(cards: result.deletedCardList)
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
