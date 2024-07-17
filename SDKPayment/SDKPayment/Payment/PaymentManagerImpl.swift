//
//  PaymentManagerImpl.swift
//  SDKPayment
//
// 
//

import Foundation
import SDKForms
import ThreeDSSDK
import PassKit

final class PaymentManagerImpl: PaymentManager {
    
    private var paymentQueue: DispatchQueue
    private weak var cardFormDelegate: CardFormDelegate!
    private weak var threeDS2WebFormDelegate: ThreeDS2WebFormDelegate!
    private weak var threeDS2SDKFormDelegate: ThreeDS2SDKFormDelegate!
    private weak var viewControllerDelegate: ViewControllerDelegate!
    
    private var checkoutConfig: CheckoutConfig!
    private var mdOrder: String!

    private var applePaySettings: ApplePaySettings?

    private lazy var dsRoot: String? = {
        if case let .use3ds2sdk(dsRoot) = viewControllerDelegate.getPaymentConfig().use3DSConfig {
            return dsRoot
        } else {
            return nil
        }
    }()
    
    private lazy var paymentApi: PaymentApi = {
        PaymentApiImpl(baseUrl: viewControllerDelegate.getPaymentConfig().baseURL)
    }()
    
    private var threeDS2Service: ThreeDS2Service = Ecom3DS2Service()
    private var transaction: Transaction?
    
    init(
        paymentQueue: DispatchQueue,
        cardFormDelegate: CardFormDelegate,
        threeDS2WebFormDelegate: ThreeDS2WebFormDelegate,
        threeDS2SDKFormDelegate: ThreeDS2SDKFormDelegate,
        viewControllerDelegate: ViewControllerDelegate
    ) {
        self.paymentQueue = paymentQueue
        self.cardFormDelegate = cardFormDelegate
        self.threeDS2WebFormDelegate = threeDS2WebFormDelegate
        self.threeDS2SDKFormDelegate = threeDS2SDKFormDelegate
        self.viewControllerDelegate = viewControllerDelegate
        
        paymentQueue.async { [weak self] in
            guard let self else { return }

            try? threeDS2SDKFormDelegate.initThreeDS2Service(threeDS2Service: threeDS2Service)
        }
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
                                                                   currencyCode: sessionStatusResponse.currencyAlphaCode)
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
            let isUse3DS2 = if case .use3ds2sdk(_) = viewControllerDelegate.getPaymentConfig().use3DSConfig { true } else { false }
            let paymentResult = if isBinding {
                try paymentApi.processBindingForm(
                    cryptogramApiData: cryptogramApiData,
                    threeDSSDK: isUse3DS2
                )
            } else {
                try paymentApi.processForm(
                    cryptogramApiData: cryptogramApiData,
                    threeDSSDK: isUse3DS2
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
            try threeDS2SDKFormDelegate.cleanup(transaction: transaction, threeDS2Service: threeDS2Service)
            try finishWithCheckOrderStatus(exception: exception)
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
            if processFormResponse.is3DSVer2 {
                LogDebug.shared.logIfDebug(
                    message: "processForm - Payment need 3DSVer2: \(processFormResponse)"
                )
                try processThreeDSData(
                    cryptogramApiData: cryptogramApiData,
                    processFormResponse: processFormResponse,
                    isBinding: isBinding
                )
                return
            }
            
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
    
    private func processThreeDSData(
        cryptogramApiData: CryptogramApiData,
        processFormResponse: ProcessFormResponse,
        isBinding: Bool
    ) throws {
        guard let threeDSSDKKey = processFormResponse.threeDSSDKKey,
              let threeDSServerTransId = processFormResponse.threeDSServerTransId
        else { throw SDKTransactionException() }
        
        do {
            try transaction?.close() // Close the previous transaction if there was one.
            guard let dsRoot = dsRoot else { 
                throw SDKException.init(message: "Please configure Use3DSConfig.use3DS2 with SDKPaymentConfig to use 3DS2")
            }
            transaction = try threeDS2Service.createTransaction(
                directoryServerID: "A000000658",
                messageVersion: "2.2.0",
                pemPublicKey: threeDSSDKKey,
                dsRoot: dsRoot,
                logoBase64: ""
            )
            
            _ = try paymentApi.getSessionStatus(mdOrder: mdOrder)
            _ = try paymentApi.getFinishedPaymentInfo(orderId: mdOrder)
            
            let paymentResult = try getProcessFormSecondResponse(
                threeDSServerTransId: threeDSServerTransId,
                transaction: transaction,
                processFormResponse: processFormResponse,
                cryptogramApiData: cryptogramApiData,
                isBinding: isBinding
            )
            
            if paymentResult.redirect?.hasPrefix("sdk://done") ?? false {
                try finishWithCheckOrderStatus()
            } else if paymentResult.errorTypeName != nil, !(paymentResult.errorTypeName?.isEmpty ?? false) {
                finishWithError(
                    exception: SDKException(message: paymentResult.errorTypeName)
                )
            } else if let _ = paymentResult.threeDSAcsRefNumber,
                      let _ = paymentResult.threeDSAcsTransactionId,
                      let _ = paymentResult.threeDSAcsSignedContent {

                try threeDS2SDKFormDelegate.openChallengeFlow(
                    transaction: transaction,
                    challengeParameters: createChallengeParameters(paymentResult: paymentResult, processFormResponse: processFormResponse),
                    challengeStatusReceiver: createChallengeStatusReceiver(processFormResponse: processFormResponse)
                )
            } else {
                finishWithError(
                    exception: SDKPaymentApiException(message: "Wrong api response from second form \(paymentResult)")
                )
            }
        } catch {
            throw error
        }
    }
    
    private func getProcessFormSecondResponse(
        threeDSServerTransId: String,
        transaction: Transaction?,
        processFormResponse: ProcessFormResponse,
        cryptogramApiData: CryptogramApiData,
        isBinding: Bool
    ) throws -> ProcessFormSecondResponse {
        guard let transaction else { throw SDKTransactionException() }

        do {
            let authRequestParams = try transaction.getAuthenticationRequestParameters()
            
            let paymentThreeDsInfo = PaymentApiImpl.PaymentThreeDSInfo(
                threeDSSDK: true,
                threeDSServerTransId: threeDSServerTransId,
                threeDSSDKEncData: authRequestParams.getDeviceData(),
                threeDSSDKEphemPubKey: authRequestParams.getSDKEphemeralPublicKey(),
                threeDSSDKAppId: authRequestParams.getSDKAppID(),
                threeDSSDKTransId: authRequestParams.getSDKTransactionID(),
                threeDSSDKReferenceNumber: authRequestParams.getSDKReferenceNumber()
            )
            
            let paymentResult = if isBinding {
                try paymentApi.processBindingFormSecond(
                    cryptogramApiData: cryptogramApiData,
                    threeDSParams: paymentThreeDsInfo
                )
            } else {
                try paymentApi.processFormSecond(
                    cryptogramApiData: cryptogramApiData,
                    threeDSParams: paymentThreeDsInfo
                )
            }
            
            return paymentResult
        } catch {
            throw error
        }
    }
    
    private func getSessionStatus() throws -> SessionStatusResponse {
        try paymentApi.getSessionStatus(mdOrder: mdOrder)
    }
    
    private func createChallengeParameters(
        paymentResult: ProcessFormSecondResponse,
        processFormResponse: ProcessFormResponse
    ) -> ChallengeParameters {
        let challengeParameters = ChallengeParameters()
        
        LogDebug.shared.logIfDebug(message: "\(paymentResult)")
        
        guard let threeDSAcsTransactionId = paymentResult.threeDSAcsTransactionId,
              let threeDSAcsRefNumber = paymentResult.threeDSAcsRefNumber,
              let threeDSAcsSignedContent = paymentResult.threeDSAcsSignedContent
        else { return challengeParameters }
        
        challengeParameters.setAcsTransactionID(threeDSAcsTransactionId)
        challengeParameters.setAcsRefNumber(threeDSAcsRefNumber)
        challengeParameters.setAcsSignedContent(threeDSAcsSignedContent)

        if let threeDSServerTransId = processFormResponse.threeDSServerTransId {
            challengeParameters.set3DSServerTransactionID(threeDSServerTransId)
        }
        
        return challengeParameters
    }
    
    /// Listener to handle the Challenge Flow execution process.
    private func createChallengeStatusReceiver(
        processFormResponse: ProcessFormResponse
    ) -> ChallengeStatusReceiver {
        ChallengeStatusReceiverImpl(
            mdOrder: mdOrder,
            paymentQueue: paymentQueue,
            threeDS2SDKFormDelegate: threeDS2SDKFormDelegate,
            transaction: transaction,
            threeDS2Service: threeDS2Service,
            processFormResponse: processFormResponse,
            paymentApi: paymentApi,
            viewControllerDelegate: viewControllerDelegate
        )
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
