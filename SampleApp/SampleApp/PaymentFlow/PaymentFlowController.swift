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
  let url = "https://ecommerce.radarpayments.com/payment";
  
  static var requestParams: RequestParams = RequestParams();
  var _paymentFlowController: CardKPaymentController!;
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

    _paymentFlowController = CardKPaymentController();
    _paymentFlowController.cardKPaymentDelegate = self;

    navController = UINavigationController(rootViewController: _paymentFlowController)
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
    CardKConfig.shared.isEditBindingListMode = true

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
  }
  
  func _fetchRootCert() {
    let request: URLRequest = URLRequest(url: URL(string: "https://dummy3dsdev.intabia.ru/acs2/secret/cert")!)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      guard let data = data else { return }
      
      CardKConfig.shared.rootCertificate = String(data: data, encoding: .utf8) ?? ""
      DispatchQueue.main.async {
        self._registerOrder()
      }
    }).resume()
  }
  
  func _fetchPubKey() {
    let urlString = String("\(self.url)/se/keys.do")
    CardKConfig.fetchKeys(urlString)
  }

  func _registerOrder() {
    _paymentFlowController = CardKPaymentController();
    _paymentFlowController.cardKPaymentDelegate = self;
    _paymentFlowController.use3ds2sdk = use3ds2sdk;
    
    API.registerNewOrder(params: PaymentFlowController.requestParams) {(data, response) in
      PaymentFlowController.requestParams.orderId = data.orderId
      self._paymentFlowController.mdOrder = data.orderId ?? ""
      
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
        
        self._paymentFlowController.directoryServerId = "directoryServerId"
        self._paymentFlowController.url = self.url;
        self._paymentFlowController.cardKPaymentView = cardKPaymentView;
        self._paymentFlowController.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
        self._paymentFlowController.headerLabel = "Custom header label";
      
        self._paymentFlowController.textDoneButtonColor = .white
        self._paymentFlowController.primaryColor = .systemBlue
        
        if #available(iOS 13.0, *) {
          self._paymentFlowController.textDoneButtonColor = .white
        }
        
        self.navController = UINavigationController(rootViewController: self._paymentFlowController)
        
        
        self.present(self.navController, animated: true, completion: nil)
      }
    }
  }
}

extension PaymentFlowController: CardKPaymentDelegate {
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
    
    self.navController.present(alert, animated: true, completion: nil)
  }
  
  func didErrorPaymentFlow(_ paymentError: CardKPaymentError!) {
    let alert = UIAlertController(title: "Error", message: paymentError.message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.navController.present(alert, animated: true, completion: nil)
  }
  
  func didCancelPaymentFlow() {
    let alert = UIAlertController(title: "Cancel", message: "Action was canceled", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
      self.dismiss(animated: true, completion: nil)
    }))
    
    self.navController.present(alert, animated: true, completion: nil)
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
