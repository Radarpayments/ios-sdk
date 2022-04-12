//
//  CardKPaymentFlowController.swift
//  CardKit
//
//  Created by Alex Korotkov on 4/7/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//


import UIKit
import ThreeDSSDK

@objc public protocol TransactionManagerDelegate {
  func errorEventReceived(message: NSString)
  func didCancel()
  func didComplete(transactionStatus: NSString)
}

@objc public class TransactionManager: NSObject {
  @objc public weak var delegate: TransactionManagerDelegate?

  @objc public var pubKey: String = ""
  @objc public var headerLabel: String = ""
  @objc public var rootCertificate: String = ""
  @objc public var directoryServerId: String = ""

  private let _uiConfig = UiCustomization()

  private var _service: ThreeDS2Service = Ecom3DS2Service()
  private var _sdkTransaction: Transaction?
  private var _sdkProgressDialog: ProgressDialog?
  private var _isInitService = false

  @objc public func initializeSdk() {
    do {
      if (!_isInitService) {
        try _service.initialize(configParameters: ConfigParameters(), locale: Locale.current.languageCode, uiCustomization: _uiConfig)
        _isInitService = true
      }

      _sdkTransaction = try _service.createTransaction(directoryServerID: directoryServerId, messageVersion: nil, publicKeyBase64: pubKey, rootCertificateBase64: rootCertificate, logoBase64: "")

      _sdkProgressDialog = try _sdkTransaction!.getProgressView()
    } catch {
      self.delegate?.errorEventReceived(message: error.localizedDescription as NSString)
    }
  }
  
  @objc public func setUpUICustomization(primaryColor: UIColor, textDoneButtonColor: UIColor) throws {
    let toolbarCustomization = ToolbarCustomization()
    try toolbarCustomization.setHeaderText(headerLabel)
    
    let buttonDoneCustomization = ButtonCustomization()
    buttonDoneCustomization.setBackgroundColor(primaryColor)
    buttonDoneCustomization.setTextColor(textDoneButtonColor)
    
    let buttonCancelCustomization = ButtonCustomization()
    buttonCancelCustomization.setBackgroundColor(.clear)
    buttonCancelCustomization.setTextColor(primaryColor)

    _uiConfig.setToolbarCustomization(toolbarCustomization)
    try _uiConfig.setButtonCustomization(buttonDoneCustomization, .submit)
    try _uiConfig.setButtonCustomization(buttonCancelCustomization, .cancel)
    try _uiConfig.setButtonCustomization(buttonDoneCustomization, .next)
  }
    
  private func _executeChallenge(delegate: ChallengeStatusReceiver ,challengeParameters: ChallengeParameters, timeout : Int32) {
    DispatchQueue.main.async(){
      do {
        try self._sdkTransaction?.doChallenge(challengeParameters: challengeParameters, challengeStatusReceiver: delegate, timeOut: Int(timeout))
      } catch {
        self.delegate?.errorEventReceived(message: error.localizedDescription as NSString)
      }
    }
  }
}

extension TransactionManager {
  @objc public func getAuthRequestParameters() -> [NSString: Any]? {
    do {
      let authRequestParams = try self._sdkTransaction?.getAuthenticationRequestParameters()
    
      return [
        "threeDSSDKEncData": authRequestParams?.getDeviceData() ?? "",
        "threeDSSDKEphemPubKey": authRequestParams?.getSDKEphemeralPublicKey() ?? "",
        "threeDSSDKAppId": authRequestParams?.getSDKAppID() ?? "",
        "threeDSSDKTransId": authRequestParams?.getSDKTransactionID() ?? ""
      ];
    } catch  {
      return nil;
    }
  }

  @objc public func handleResponse (aRes: ARes) {
    let challengeParameters = ChallengeParameters()
    challengeParameters.setAcsSignedContent(aRes.acsSignedContent)
    challengeParameters.setAcsRefNumber(aRes.acsReferenceNumber)
    challengeParameters.setAcsTransactionID(aRes.acsTransID)
    challengeParameters.set3DSServerTransactionID(aRes.threeDSServerTransID)
  
    _executeChallenge(delegate: self, challengeParameters: challengeParameters , timeout: 5)
  }
  
  @objc public func showProgressDialog() {
    _sdkProgressDialog?.show();
  }
  
  @objc public func closeProgressDialog() {
    _sdkProgressDialog?.close();
  }
}

extension TransactionManager: ChallengeStatusReceiver {
  public func completed(completionEvent e: CompletionEvent) {
    let transactionStatus: NSString = e.getTransactionStatus() as NSString
    
    delegate?.didComplete(transactionStatus: transactionStatus)
  }
  
  public func cancelled() {
    delegate?.didCancel()
  }

  public func timedout() {
    delegate?.errorEventReceived(message: "Timedout error")
  }

  public func protocolError(protocolErrorEvent e: ProtocolErrorEvent) {
    delegate?.errorEventReceived(message: e.getErrorMessage().getErrorDescription() as NSString)
  }
  
  public func runtimeError(runtimeErrorEvent: RuntimeErrorEvent) {
    delegate?.errorEventReceived(message: runtimeErrorEvent.errorMessage as NSString)
  }
}
