//
//  TransactionMeneger.swift
//  SampleApp3DS2
//
//  Created by Alex Korotkov on 12/14/20.
//

import UIKit
import ThreeDSSDK


public protocol TransactionManagerDelegate: AnyObject {
    func finishOrder() -> Void
}

public class TransactionManager: NSObject {
  weak var delegate: TransactionManagerDelegate?

  var pubKey: String = ""
  var directoryServerId: String = ""
  var rootCI: String = ""
  var useCustomTheme: Bool = false
  
  private var _service: ThreeDS2Service = Ecom3DS2Service()
  private var _sdkTransaction: Transaction?
  private var _sdkProgressDialog: ProgressDialog?
  private let _notificationCenter = NotificationCenter.default

  public func initializeSdk() throws {
    try _service.initialize(configParameters: ConfigParameters(), locale: Locale.current.languageCode, uiCustomization: _setUpTheme())

    _sdkTransaction = try _service.createTransaction(directoryServerID: directoryServerId, messageVersion: nil, publicKeyBase64: pubKey, rootCertificateBase64: rootCI, logoBase64: "")

    _sdkProgressDialog = try _sdkTransaction!.getProgressView()
  }
  
  private func _setUpTheme() throws -> UiCustomization {
    let uiConfig = UiCustomization()

    if (!useCustomTheme) {
      return uiConfig
    }

    let indigoColor = UIColor(red: 0.25, green: 0.32, blue: 0.71, alpha: 1.00)
    
    var toolbarColor: UIColor = indigoColor
    var textColor: UIColor = .white
    var buttonDone: UIColor = indigoColor
    var buttonResend: UIColor = indigoColor
    
    if #available(iOS 11.0, *) {
      toolbarColor = UIColor(named: "toolbarColor") ?? toolbarColor
      textColor = UIColor(named: "textColor") ?? textColor
      buttonDone = UIColor(named: "buttonDone") ?? buttonDone
      buttonResend = UIColor(named: "buttonResend") ?? buttonResend
    }
    
    let toolbarCustomization = ToolbarCustomization()
    try toolbarCustomization.setHeaderText("SECURE CHECKOUT")
    toolbarCustomization.setBackgroundColor(toolbarColor)
    toolbarCustomization.setTextColor(.white)
    
    let textBoxCustomization = TextBoxCustomization()
    try textBoxCustomization.setBorderWidth(1)
    textBoxCustomization.setBorderColor(.gray)
    textBoxCustomization.setTextColor(textColor)
    
    let buttonDoneCustomization = ButtonCustomization()
    buttonDoneCustomization.setBackgroundColor(buttonDone)
    buttonDoneCustomization.setTextColor(.white)
    
    let buttonCancelCustomization = ButtonCustomization()
    buttonCancelCustomization.setBackgroundColor(.clear)
    buttonCancelCustomization.setTextColor(.white)
    
    let buttonResendCustomization = ButtonCustomization()
    buttonResendCustomization.setBackgroundColor(.clear)
    buttonResendCustomization.setTextColor(buttonResend)
    
    let titleCustomization = LabelCustomization()
    titleCustomization.setTextColor(textColor)
    titleCustomization.setHeadingTextColor(textColor)

    uiConfig.setToolbarCustomization(toolbarCustomization)
    uiConfig.setTextBoxCustomization(textBoxCustomization)
    uiConfig.setLabelCustomization(titleCustomization)
    try uiConfig.setButtonCustomization(buttonDoneCustomization, .submit)
    try uiConfig.setButtonCustomization(buttonCancelCustomization, .cancel)
    try uiConfig.setButtonCustomization(buttonResendCustomization, .resend)
    
    return uiConfig
  }

  private func _executeChallenge(delegate: ChallengeStatusReceiver ,challengeParameters: ChallengeParameters, timeout : Int32) {
    DispatchQueue.main.async() {
      do {
        try self._sdkTransaction?.doChallenge(challengeParameters: challengeParameters, challengeStatusReceiver: delegate, timeOut: Int(timeout))
      } catch {
        self.close()
      }
    }
  }
}

extension TransactionManager {
  public func getAuthRequestParameters() throws -> ThreeDSSDK.AuthenticationRequestParameters {
    return try _sdkTransaction!.getAuthenticationRequestParameters();
  }

  public func handleResponse (responseObject: [String : String]){
    let challengeParameters = ChallengeParameters()
    challengeParameters.setAcsSignedContent(responseObject["acsSignedContent"]!)
    challengeParameters.setAcsRefNumber(responseObject["acsReferenceNumber"]!)
    challengeParameters.setAcsTransactionID(responseObject["acsTransID"]!)
    challengeParameters.set3DSServerTransactionID(responseObject["threeDSServerTransID"]!)
    
    _executeChallenge(delegate: self, challengeParameters: challengeParameters , timeout: 5)
  }
  
  public func showProgressDialog() {
    _sdkProgressDialog?.show()
  }

  public func closeProgressDialog() {
    _sdkProgressDialog?.close()
  }
  
  public func close() {
    do {
      try _sdkTransaction?.close()
    } catch {
      print("Can not close sdk transaction \(error.localizedDescription)")
    }
  }
}

extension TransactionManager: ChallengeStatusReceiver {
  private func _reloadTable() {
    _notificationCenter.post(name: Notification.Name("_reloadTable"), object: nil)
  }
  
  public func completed(completionEvent e: CompletionEvent) {
    delegate?.finishOrder()
  }

  public func cancelled() {
    _reloadTable()
  }

  public func timedout() {
    _reloadTable()
  }

  public func protocolError(protocolErrorEvent e: ProtocolErrorEvent) {
    _reloadTable()
  }
  
  public func runtimeError(runtimeErrorEvent: RuntimeErrorEvent) {
    _reloadTable()
  }
}
