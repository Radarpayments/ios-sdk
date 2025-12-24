//
//  PaymentManagerImpl.swift
//  SDKPayment
//
// 
//

import Foundation
import PassKit

final class PaymentManagerImpl: PaymentManager {
    
    private var paymentQueue: DispatchQueue
    private weak var cardFormDelegate: CardFormDelegate!
    private weak var threeDS2WebFormDelegate: ThreeDS2WebFormDelegate!
    private weak var viewControllerDelegate: ViewControllerDelegate!
    
    private var checkoutConfig: CheckoutConfig!
    private var mdOrder: String!

    private var applePaySettings: ApplePaySettings?
    
    private lazy var paymentApi: PaymentApi = {
        PaymentApiImpl(baseUrl: viewControllerDelegate.getPaymentConfig().baseURL)
    }()
    
    init(
        paymentQueue: DispatchQueue,
        cardFormDelegate: CardFormDelegate,
        threeDS2WebFormDelegate: ThreeDS2WebFormDelegate,
        viewControllerDelegate: ViewControllerDelegate
    ) {
        self.paymentQueue = paymentQueue
        self.cardFormDelegate = cardFormDelegate
        self.threeDS2WebFormDelegate = threeDS2WebFormDelegate
        self.viewControllerDelegate = viewControllerDelegate
    }
    
    func checkout(config: CheckoutConfig) throws {
        // start PaymentActivity
        // The first step is to call the getSessionStatus method
        // Payment configuration ->
        // 1 - Run SDK Form
        // a - New map screen
        // b - Linked cards
        // 2 - Call the payment method for a new card or linked
        // a - Method of payment with a new card
        // b - Payment method with linked card
        // 3 Call the method of processing the result
        // a - payment was successful
        // finish
        // b - Need 3DS
        // 3.b.1 - launch SDK 3DS (challenge flow)
        // c - Get an error
        // 4 - Completion with the result of the payment (return to the payment start screen).
        checkoutConfig = config

        switch config.id {
        case let .sessionId(id):
            guard let extractedMdOrder = SessionIdUtils().extractValue(from: id) else {
                finishWithError(exception: SDKIncorrectSessionIdException())
                return
            }
            mdOrder = extractedMdOrder

        case let .mdOrder(id):
            mdOrder = id
        }
        
        do {
            let sessionStatusResponse = try getSessionStatus()
            let isApplePayAccepted = sessionStatusResponse.merchantOptions.contains(.applePay)
            
            if isApplePayAccepted {
                self.applePaySettings = viewControllerDelegate.getPaymentConfig().applePaySettings
            }
            
            if sessionStatusResponse.remainingSecs == nil {
                let response = try getFinishedPaymentInfo(mdOrder: mdOrder)
                let successPaymentStatusList = [OrderStatus.deposited.rawValue, OrderStatus.approved.rawValue]
                
                if let status = response.status {
                    if status.containsAnyOfKeywordIgnoreCase(keywords: successPaymentStatusList) {
                        finishWithError(exception: SDKAlreadyPaymentException())
                        return
                    }
                    
                    if status.containsAnyOfKeywordIgnoreCase(keywords: [OrderStatus.declined.rawValue]) {
                        finishWithError(exception: SDKDeclinedException())
                        return
                    }
                } else {
                    let exception: SDKException
                    switch checkoutConfig.id {
                    case .sessionId(_):
                        exception = SDKSessionNotExistException()
                    case .mdOrder(_):
                        exception = SDKOrderNotExistException()
                    }
                    finishWithError(exception: exception)
                }
                
                return
            }
            
            if sessionStatusResponse.bindingItems.isEmpty {
                LogDebug.shared.logIfDebug(message: "Creating cryptogram with New Card")
            } else {
                LogDebug.shared.logIfDebug(message: "Creating cryptogram with Binding Card")
            }
            
            try cardFormDelegate.openBottomSheet(
                mdOrder: mdOrder,
                bindingEnabled: sessionStatusResponse.bindingEnabled,
                bindingCards: sessionStatusResponse.bindingItems,
                cvcNotRequired: sessionStatusResponse.cvcNotRequired,
                bindingDeactivationEnabled: sessionStatusResponse.bindingDeactivationEnabled,
                applePayPaymentConfig: createApplePayPaymentConfig(applePaySettings: applePaySettings, 
                                                                   currencyCode: sessionStatusResponse.currencyAlphaCode),
                sessionStatus: sessionStatusResponse
            )
        } catch {
            finishWithError(exception: error as? SDKException)
        }
    }
    
    func finishWithCheckOrderStatus(exception: SDKException? = nil) throws {
        do {
            let orderStatus = try getSessionStatus()
            let paymentFinishInfo = try getFinishedPaymentInfo(mdOrder: mdOrder)
            
            LogDebug.shared.logIfDebug(
                message: "getSessionStatus - Remaining sec \(String(describing: orderStatus.remainingSecs))"
            )

            let isSuccess = paymentFinishInfo.status?
                .containsAnyOfKeywordIgnoreCase(keywords: OrderStatuses.payedStatuses) ?? false
            
            let paymentResultData = PaymentResultData(isSuccess: isSuccess,
                                                      exception: exception)
            viewControllerDelegate?.finishWithResult(paymentData: paymentResultData)
        } catch { throw error }
    }
    
    /// Start the payment process by calling the API methods.
    ///
    /// - Parameters:
    ///     - cryptogramApiData result of the creating a cryptogram.
    func processFormData(cryptogramApiData: CryptogramApiData, isBinding: Bool) throws {
        do {
            let paymentResult = if isBinding {
                try paymentApi.processBindingForm(
                    cryptogramApiData: cryptogramApiData
                )
            } else {
                try paymentApi.processForm(
                    cryptogramApiData: cryptogramApiData
                )
            }
            
            try handleProcessFormResponse(
                cryptogramApiData: cryptogramApiData,
                processFormResponse: paymentResult,
                isBinding: isBinding
            )
        } catch {
            throw error
        }
    }
    
    /// Start the payment process with ApplePay by calling the API methods
    ///
    ///  - Parameters:
    ///     - cryptogramApplePayApiData result of ApplePay auth process
    func processApplePay(cryptogramApplePayApiData: CryptogramApplePayApiData) throws {
        do {
            _ = try paymentApi.processApplePay(cryptogramApplePayApiData: cryptogramApplePayApiData)
            try finishWithCheckOrderStatus()
        }
        catch { throw error }
    }
    
    /// Unbind card on server.
    ///
    /// - Parameters:
    ///     - bindingId identifier of binding card.
    /// - Returns: true if success, otherwise false
    func unbindCard(bindingId: String) -> Bool {
        let isSuccess = try? paymentApi.unbindCardAnonymous(bindingId: bindingId, mdOrder: mdOrder).isSuccess
        return isSuccess ?? false
    }
    
    /// Canceling the process of creating a cryptogram.
    func finishWithError<T: SDKException>(exception: T?) {
        do {
            if exception is SDKCancelledException {
                let paymentResultData = PaymentResultData(isSuccess: false,
                                                          exception: exception as? SDKCancelledException)
                viewControllerDelegate?.finishWithResult(paymentData: paymentResultData)
            } else {
                try finishWithCheckOrderStatus(exception: exception)
            }
        } catch {
            let paymentResultData = PaymentResultData(isSuccess: false,
                                                      exception: error as? SDKException)
            viewControllerDelegate?.finishWithResult(paymentData: paymentResultData)
        }
    }
    
    private func handleProcessFormResponse(
        cryptogramApiData: CryptogramApiData,
        processFormResponse: ProcessFormResponse,
        isBinding: Bool
    ) throws {
        if processFormResponse.threeDSMethodURL != nil {
            LogDebug.shared.logIfDebug(
                message: "Merchant is not configured to be used without 3DS2SDK: \(processFormResponse)"
            )
            throw SDKNotConfigureException(
                message: "Merchant is not configured to be used without 3DS2SDK"
            )
        }
        
        do {
            if let acsUrl = processFormResponse.acsUrl,
               let paReq = processFormResponse.paReq,
               let termUrl = processFormResponse.termUrl {

                LogDebug.shared.logIfDebug(
                    message: "processForm - Payment need 3DSVer1: \(processFormResponse)"
                )
                threeDS2WebFormDelegate.openWebChallenge(
                    webChallengeParam: WebChallengeParam(
                        mdOrder: cryptogramApiData.mdOrder,
                        acsUrl: acsUrl,
                        paReq: paReq,
                        termUrl: termUrl
                    )
                )
                return
            }
            
            LogDebug.shared.logIfDebug(
                message: "processForm - Payment without 3DS: \(processFormResponse)"
            )
            try finishWithCheckOrderStatus()
        } catch {
            throw error
        }
    }
    
    private func getFinishedPaymentInfo(mdOrder: String) throws -> FinishedPaymentInfoResponse {
        try paymentApi.getFinishedPaymentInfo(orderId: mdOrder)
    }
    
    private func getSessionStatus() throws -> SessionStatusResponse {
        try paymentApi.getSessionStatus(mdOrder: mdOrder)
    }
    
    private func createApplePayPaymentConfig(applePaySettings: ApplePaySettings?, currencyCode: String?) -> ApplePayPaymentConfig? {
        guard let applePaySettings, let currencyCode else { return nil }

        let mapper = NetworkSystemMapper()
        let supportedNetworks = applePaySettings.availablePaymentSystems.compactMap(mapper.networktSystem)
        
        return ApplePayPaymentConfig(
            merchantId: applePaySettings.merchantId,
            currencyCode: currencyCode,
            countryCode: applePaySettings.countryCode,
            supportedNetworks: supportedNetworks,
            items: applePaySettings.summaryItems.map {
                ApplePayPaymentConfig
                    .SummaryItem(label: $0.label, amount: $0.amount)
            }
        )
    }
}
