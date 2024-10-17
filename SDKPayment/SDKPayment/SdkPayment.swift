//
//  SDKPayment.swift
//  SDKPayment
//
// 
//

import Foundation
import UIKit
import SDKForms
import SDKCore

public final class SdkPayment {
    
    public static let shared = SdkPayment()
    
    private var innerSDKPaymentConfig: SDKPaymentConfig?
    
    private init() {}
    
    public static func initialize(sdkPaymentConfig: SDKPaymentConfig) -> SdkPayment {
        shared.innerSDKPaymentConfig = sdkPaymentConfig
        
        let sdkConfigBuilder = SDKConfigBuilder()
        let keyProvider = RemoteKeyProvider(url: sdkPaymentConfig.keyProviderUrl)
        
        if let sdkConfig = try? sdkConfigBuilder
            .keyProvider(provider: keyProvider)
            .build() {

            _ = SdkForms.initialize(sdkConfig: sdkConfig)
        }
        
        return shared
    }
    
    public func sdkPaymnetConfig() throws -> SDKPaymentConfig {
        if let innerSDKPaymentConfig { return innerSDKPaymentConfig }
        
        throw SDKException(message: "Please call SDKPayment.initialize(sdkPaymentConfig:) before.")
    }
    
    /// Starting the billing cycle process via SDK from controller.
    ///
    /// - Parameters:
    ///     - controller to which the result will be returned.
    ///     - mdOrder order number.
    public func checkoutWithBottomSheet(
        controller: UINavigationController,
        mdOrder: String,
        callbackHandler: any ResultPaymentCallback<PaymentResult>
    ) {
        Logger.shared.log(
            classMethod: type(of: self),
            tag: Constants.TAG,
            message: "checkoutWithBottomSheet(\(controller), \(mdOrder): ",
            exception: nil
        )
        
        do {
            let paymentController = PaymentController(
                mdOrder: mdOrder,
                parentController: controller,
                callbackHandler: callbackHandler
            )

            try paymentController.startPaymentFlow()
        } catch {
            let resultPayment = PaymentResult(mdOrder: mdOrder,
                                              isSuccess: false,
                                              exception: error as? SDKException)

            callbackHandler.onResult(result: resultPayment)
        }
    }
    
    private func getExceptionTypesMessage(exception: SDKException?) -> String? {
        if let exception {
            switch exception {
            case _ as SDKAlreadyPaymentException: return "payment of a successfully paid order"
            case _ as SDKCryptogramException: return "error while creating cryptogram"
            case _ as SDKDeclinedException: return "order was canceled on previous payment cycle"
            case _ as SDKPaymentApiException: return "error when working with gateway API methods"
            case _ as SDKTransactionException: return "error when creating a transaction when paying through 3ds"
            case _ as SDKOrderNotExistException: return "payment for a non-existent order"
            default: return nil
            }
        }
        
        return nil
    }
    
    public static func getSDKVersion() -> String {
        let version = "3.0.2.1"
        LogDebug.shared.logIfDebug(message: "SDKPayment version is: \(version)")
        LogDebug.shared.logIfDebug(message: "SDKForms version is: \(SdkForms.getSDKVersion())")
        LogDebug.shared.logIfDebug(message: "SDKCore version is: \(SdkCore.getSDKVersion())")
        LogDebug.shared.logIfDebug(message: "SDKThreeDS version is: \(version)")
        
        return version
    }
}
