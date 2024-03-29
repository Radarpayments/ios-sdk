//
//  PaymentFlowController.swift
//  SampleApp
//
//  Created by Alex Korotkov on 3/30/21.
//  Copyright © 2021 AnjLab. All rights reserved.


import Foundation
import CardKitPayment

class PaymentFlowController: UIViewController {
  var sampleAppCardIO: SampleAppCardIO? = nil
  var navController: UINavigationController!
  let url = "https://dev.bpcbt.com/payment";
  
  static var requestParams: RequestParams = RequestParams();
  var _paymentFlowManager: CardKPaymentManager!;
  var amount: String {
      get {
        return PaymentFlowController.requestParams.amount ?? ""
      }
      set(newAmount) {
        PaymentFlowController.requestParams.amount = newAmount
      }
  }
  
  var use3ds2sdk: Bool = true;
  var _button: UIButton = UIButton();

  init() {
    super.init(nibName: nil, bundle: nil)

    _paymentFlowManager = CardKPaymentManager();
    _paymentFlowManager.cardKPaymentDelegate = self;

    self.view.addSubview(_button)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 13.0, *) {
      self.view.backgroundColor = .systemGray6
      CardKConfig.shared.theme = CardKTheme.system()
    } else {
      self.view.backgroundColor = .white
      CardKConfig.shared.theme = CardKTheme.light()
    };

    _button.setTitleColor(.systemBlue, for: .normal)
    
    CardKConfig.shared.language = "en";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.isEditBindingListMode = true;
    PaymentFlowController.requestParams.userName = "mobile-sdk-api"
    PaymentFlowController.requestParams.password = "vkyvbG0"
    PaymentFlowController.requestParams.returnUrl = "sdk://done"
    PaymentFlowController.requestParams.email = "test@test.com"
    PaymentFlowController.requestParams.text = "DE DE"
    PaymentFlowController.requestParams.threeDSSDK = "true"
    PaymentFlowController.requestParams.clientId = ProcessInfo.processInfo.environment["CLIENT_ID"] ?? "ClientIdTestIOS"
  
    _button.setTitle("Start Payement flow", for: .normal);
    _button.frame = CGRect(x: 0, y: 0, width: 200, height: 100);
    _button.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2);
    _button.addTarget(self, action: #selector(_pressedButton), for: .touchDown);
  }
  
  @objc func _pressedButton() {
    _fetchRootCert()
    _fetchPubKey()
    _registerOrder()
  }
  
  func _fetchRootCert() {
    CardKConfig.shared.rootCertificate = """
            MIICDTCCAbOgAwIBAgIUOO3a573khC9kCsQJGKj/PpKOSl8wCgYIKoZIzj0EA
            wIwXDELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBA
            oMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDEVMBMGA1UEAwwMZHVtbXkzZHN
            yb290MB4XDTIxMDkxNDA2NDQ1OVoXDTMxMDkxMjA2NDQ1OVowXDELMAkGA1UE
            BhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0I
            FdpZGdpdHMgUHR5IEx0ZDEVMBMGA1UEAwwMZHVtbXkzZHNyb290MFkwEwYHKo
            ZIzj0CAQYIKoZIzj0DAQcDQgAE//e+MhwdgWxkFpexkjBCx8FtJ24KznHRXMS
            WabTrRYwdSZMScgwdpG1QvDO/ErTtW8IwouvDRlR2ViheGr02bqNTMFEwHQYD
            VR0OBBYEFHK/QzMXw3kW9UzY5w9LVOXr+6YpMB8GA1UdIwQYMBaAFHK/QzMXw
            3kW9UzY5w9LVOXr+6YpMA8GA1UdEwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSA
            AwRQIhAOPEiotH3HJPIjlrj9/0m3BjlgvME0EhGn+pBzoX7Z3LAiAOtAFtkip
            d9T5c9qwFAqpjqwS9sSm5odIzk7ug8wow4Q==
            """
  }
  
  func _fetchPubKey() {
    let urlString = String("\(self.url)/se/keys.do")
    CardKConfig.fetchKeys(urlString);
  }

  func _registerOrder() {
    API.registerNewOrder(params: PaymentFlowController.requestParams) {(data, response) in
      PaymentFlowController.requestParams.orderId = data.orderId
      
      let amountDecimal = NSDecimalNumber (string: PaymentFlowController.requestParams.amount)
      
      DispatchQueue.main.async {
        let paymentRequest = PKPaymentRequest();
        paymentRequest.currencyCode = "USD";
        paymentRequest.countryCode = "US";
        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
        paymentRequest.supportedNetworks = [.visa, .amex, .masterCard];
        paymentRequest.paymentSummaryItems = [
          PKPaymentSummaryItem(label: "Box", amount: amountDecimal)
        ];
        
        let cardPayButton = UIButton();
        cardPayButton.backgroundColor = .systemBlue;
        cardPayButton.setTitleColor(.white, for: .normal)
        cardPayButton.setTitle("New card", for: .normal)
        
        let cardKPaymentView = CardKPaymentView();
        cardKPaymentView.merchantId = "merchant.cardkit";
        cardKPaymentView.paymentRequest = paymentRequest;
        cardKPaymentView.paymentButtonStyle = .black;
        cardKPaymentView.paymentButtonType = .buy;
        cardKPaymentView.cardPaybutton = cardPayButton;
        cardKPaymentView.paymentRequest.merchantIdentifier = "merchant.cardkit";
        
        self._paymentFlowManager = CardKPaymentManager();
        self._paymentFlowManager.cardKPaymentDelegate = self;
        self._paymentFlowManager.use3ds2sdk = self.use3ds2sdk;
        self._paymentFlowManager.mdOrder = data.orderId ?? ""
        self._paymentFlowManager.directoryServerId = "directoryServerId"
        self._paymentFlowManager.url = self.url;
        self._paymentFlowManager.cardKPaymentView = cardKPaymentView;
        self._paymentFlowManager.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
        self._paymentFlowManager.headerLabel = "Custom header label";
      
        self._paymentFlowManager.textDoneButtonColor = .white
        self._paymentFlowManager.primaryColor = .systemBlue
        
        if #available(iOS 13.0, *) {
          self._paymentFlowManager.textDoneButtonColor = .white
        }
        
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        self._paymentFlowManager.presentViewController(self.navigationController);
      }
    }
  }
}

extension PaymentFlowController: CardKPaymentManagerDelegate {
  func didFinishPaymentFlow(_ paymentInfo: [AnyHashable : Any]!) {
    print("didFinishPaymentFlow")
    var message = ""
    for key in paymentInfo.keys {
      message = "\(message) \n \(key) = \(paymentInfo[key] ?? "")"
    }

    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
      self.dismiss(animated: true, completion: nil)
    }))
    
    self._paymentFlowManager.sdkNavigationController.present(alert, animated: true, completion: nil)
  }
  
  func didErrorPaymentFlow(_ paymentError: CardKPaymentError!) {
    let alert = UIAlertController(title: "Error", message: paymentError.message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self._paymentFlowManager.sdkNavigationController.present(alert, animated: true, completion: nil)
  }
  
  func didCancelPaymentFlow() {
    let alert = UIAlertController(title: "Cancel", message: "Action was canceled", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
      self.dismiss(animated: true, completion: nil)
    }))
    
    self._paymentFlowManager.sdkNavigationController.present(alert, animated: true, completion: nil)
  }
  
  func scanCardRequest(_ controller: CardKViewController) {
    let cardIO = CardIOView(frame: controller.view.bounds)
    cardIO.hideCardIOLogo = true
    cardIO.scanExpiry = false
    cardIO.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    sampleAppCardIO = SampleAppCardIO()
    sampleAppCardIO?.cardKController = controller
    cardIO.delegate = sampleAppCardIO
    
    controller.showScanCardView(cardIO, animated: true)
  }
}
