//
//  ChallengeStatusReceiverImpl.swift
//  SDKPayment
//
// 
//

import Foundation
import ThreeDSSDK

final class ChallengeStatusReceiverImpl: ChallengeStatusReceiver {
    
    private var mdOrder: String?
    private var paymentQueue: DispatchQueue
    private var threeDS2SDKFormDelegate: ThreeDS2SDKFormDelegate
    private var transaction: Transaction?
    private var threeDS2Service: ThreeDS2Service
    private var processFormResponse: ProcessFormResponse
    private var paymentApi: PaymentApi
    private var viewControllerDelegate: ViewControllerDelegate?
    
    init(
        mdOrder: String?,
        paymentQueue: DispatchQueue,
        threeDS2SDKFormDelegate: ThreeDS2SDKFormDelegate,
        transaction: Transaction?,
        threeDS2Service: ThreeDS2Service,
        processFormResponse: ProcessFormResponse,
        paymentApi: PaymentApi,
        viewControllerDelegate: ViewControllerDelegate?
    ) {
        self.mdOrder = mdOrder
        self.paymentQueue = paymentQueue
        self.threeDS2SDKFormDelegate = threeDS2SDKFormDelegate
        self.transaction = transaction
        self.threeDS2Service = threeDS2Service
        self.processFormResponse = processFormResponse
        self.paymentApi = paymentApi
        self.viewControllerDelegate = viewControllerDelegate
    }
    
    func completed(completionEvent: CompletionEvent) {
        paymentQueue.sync { [weak self] in
            guard let self else { return }
            logIfDebugAndCleanup(logMessage: "completed \(completionEvent)")
            
            switch completionEvent.getTransactionStatus() {
            case "Y":
                if let threeDSServerTransId = processFormResponse.threeDSServerTransId {
                    try? self.paymentApi.finish3dsVer2PaymentAnonymous(
                        threeDSServerTransId: threeDSServerTransId
                    )
                    try? self.checkOrderStatus(order: mdOrder)
                }
            case "N":
                try? self.checkOrderStatus(order: mdOrder)
            default:
                break
            }
        }
    }
    
    func cancelled() {
        logIfDebugAndCleanup(logMessage: "cancelled")
    }
    
    func timedout() {
        logIfDebugAndCleanup(logMessage: "timedout")
    }
    
    func protocolError(protocolErrorEvent: ProtocolErrorEvent) {
        logIfDebugAndCleanup(logMessage: "protocolError \(protocolErrorEvent)")
    }
    
    func runtimeError(runtimeErrorEvent: RuntimeErrorEvent) {
        logIfDebugAndCleanup(logMessage: "runtimeError \(runtimeErrorEvent)")
    }
    
    private func logIfDebugAndCleanup(logMessage: String) {
        LogDebug.shared.logIfDebug(message: logMessage)

        try? threeDS2SDKFormDelegate.cleanup(
            transaction: transaction,
            threeDS2Service: threeDS2Service
        )
    }
    
    private func checkOrderStatus(order: String?) throws {
        guard let order else { return }

        do {
            let orderStatus = try getSessionStatus()
            let paymentFinishInfo = try getFinishedPaymentInfo(mdOrder: order)
            
            LogDebug.shared.logIfDebug(
                message: "getSessionStatus - Remaining sec \(String(describing: orderStatus.remainingSecs))"
            )
            
            let isSuccess = paymentFinishInfo.status?
                .containsAnyOfKeywordIgnoreCase(keywords: OrderStatuses.payedStatuses) ?? false
            
            let paymentResult = PaymentResult(
                mdOrder: order,
                isSuccess: isSuccess
            )
            
            viewControllerDelegate?.finishWithResult(
                paymentData: paymentResult
            )
        } catch { throw error }
    }
    
    private func getSessionStatus() throws -> SessionStatusResponse {
        try paymentApi.getSessionStatus(mdOrder: mdOrder ?? "")
    }
    
    private func getFinishedPaymentInfo(mdOrder: String) throws -> FinishedPaymentInfoResponse {
        try paymentApi.getFinishedPaymentInfo(orderId: mdOrder)
    }
}
