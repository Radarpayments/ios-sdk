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
    
    private var mdOrder: String
    private var parentController: UINavigationController
    private var callbackHandler: any ResultPaymentCallback<PaymentResult>
    private let paymentQueue = DispatchQueue(label: "paymentQueue", attributes: .concurrent)
    
    private lazy var cardFormDelegate: CardFormDelegate = {
        CardFormDelegateImpl(
            parentController: parentController,
            resultCryptogramCallback: self
        )
    }()
    
    private lazy var threeDS1FormDelegate: ThreeDS1FormDelegate = {
        ThreeDS1FormDelegateImpl(
            parentController: parentController,
            viewControllerDelegate: self
        )
    }()

    private lazy var threeDS2FormDelegate: ThreeDS2FormDelegate = {
        ThreeDS2FormDelegateImpl(
            parentController: parentController,
            viewControllerDelegate: self
        )
    }()
    
    private lazy var paymentManager: PaymentManagerImpl = {
        PaymentManagerImpl(
            paymentQueue: paymentQueue,
            cardFormDelegate: cardFormDelegate,
            threeDS1FormDelegate: threeDS1FormDelegate,
            threeDS2FormDelegate: threeDS2FormDelegate,
            viewControllerDelegate: self
        )
    }()
    
    init(
        mdOrder: String,
        parentController: UINavigationController,
        callbackHandler: any ResultPaymentCallback<PaymentResult>
    ) {
        self.mdOrder = mdOrder
        self.parentController = parentController
        self.callbackHandler = callbackHandler
    }
    
    func startPaymentFlow() throws {
        do { try paymentManager.checkout(order: mdOrder) } 
        catch { throw error }
    }
    
    private func paymentNewCard(
        seToken: String,
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
                        seToken: seToken,
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
        seToken: String,
        paymentInfo: PaymentInfoBindCard,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                try paymentManager.processFormData(
                    cryptogramApiData: CryptogramApiData(
                        seToken: seToken,
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
        seToken: String,
        paymentInfo: PaymentInfoApplePay,
        completion: @escaping (_ error: SDKException?) -> Void
    ) {
        paymentQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                try paymentManager.processApplePay(
                    cryptogramApplePayApiData: CryptogramApplePayApiData(
                        mdOrder: paymentInfo.order,
                        paymentToken: seToken
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

    func finishWithResult(paymentData: PaymentResult) {
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
                
                callbackHandler.onResult(result: paymentData)
            
            case let topViewController as ViewController3DS1Challenge:
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
                callbackHandler.onResult(result: paymentData)
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
                paymentNewCard(seToken: result.seToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResult = PaymentResult(mdOrder: mdOrder, isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResult)
                }
            case let info as PaymentInfoBindCard:
                paymentBindingCard(seToken: result.seToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResult = PaymentResult(mdOrder: mdOrder, isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResult)
                }
            case let info as PaymentInfoApplePay:
                paymentApplePay(seToken: result.seToken, paymentInfo: info) { [weak self] error in
                    guard let self else { return }
                    
                    let paymentResult = PaymentResult(mdOrder: mdOrder, isSuccess: false, exception: error)
                    finishWithResult(paymentData: paymentResult)
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
