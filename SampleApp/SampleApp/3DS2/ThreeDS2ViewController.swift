//
//  SampleCardKPaymentView.swift
//  SampleApp
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

import UIKit
import CardKit

class ThreeDS2ViewController: UITableViewController, TransactionManagerDelegate, UITextFieldDelegate {
  static var logs: NSMutableArray = NSMutableArray()
  
  private let _notificationCenter = NotificationCenter.default
  private let _headerView = UIView()
  private let _textFieldBaseUrl = TextField3DS2Example()
  private let _textFieldCost = TextField3DS2Example()
  private let _textFieldUserName = TextField3DS2Example()
  private let _textFieldPassword = TextField3DS2Example()
  private let _textFieldRootCI = TextField3DS2Example()
  private let _textFieldDirectoryServerId = TextField3DS2Example()
  private var _transactionManager = TransactionManager()
  private var _requestParams = RequestParams()

  
  init(style: UITableView.Style, useCustomTheme: Bool) {
    self._transactionManager.useCustomTheme = useCustomTheme
    super.init(style: style)
  }

  override init(style: UITableView.Style) {
    super.init(style: style)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func addLog(title: String, request: String, response: String, isReload: Bool = false) {
    ThreeDS2ViewController.logs.add(["title": title, "response": response, "request": request])
    
    if isReload {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self._fetchRootCI()
    
    ThreeDS2ViewController.logs.removeAllObjects()
    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system()
    } else {
      CardKConfig.shared.theme = CardKTheme.light()
    };
    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = [];
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";

    _transactionManager.delegate = self
    _textFieldBaseUrl.text = url
    _textFieldBaseUrl.placeholder = "url"
    _textFieldBaseUrl.delegate = self
    
    _textFieldCost.text = "2000"
    _textFieldCost.keyboardType = .numberPad
    _textFieldCost.placeholder = "Price"
    
    _textFieldPassword.text = "vkyvbG0"
    _textFieldPassword.isSecureTextEntry = true
    _textFieldPassword.placeholder = "Password"
    
    _textFieldUserName.text = "mobile-sdk-api"
    _textFieldUserName.placeholder = "User name"
    
    _textFieldRootCI.placeholder = "Root CI"

    _textFieldDirectoryServerId.text = "directoryServerId"
    _textFieldDirectoryServerId.placeholder = "Directory server id"
    
    let textFields = [_textFieldBaseUrl, _textFieldCost, _textFieldPassword, _textFieldUserName, _textFieldDirectoryServerId, _textFieldRootCI]
    
    textFields.forEach({textField in
      _headerView.addSubview(textField)
    })

    self.tableView.tableHeaderView = _headerView
  
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 44
    self.tableView.separatorStyle = .none
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.setNeedsLayout()
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    self.tableView.autoresizingMask = .flexibleWidth
    
    _textFieldBaseUrl.addTarget(self, action: #selector(self._textFieldDidEndEditing), for: .editingDidEnd)
    _notificationCenter.addObserver(self, selector: #selector(_reloadTableView), name: Notification.Name("ReloadTable"), object: nil)
    self._fetchPubKey()
  }
  
  func _fetchRootCI() {
    let request: URLRequest = URLRequest(url: URL(string: "https://dummy3dsdev.intabia.ru/acs2/secret/cert")!)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      guard let data = data else { return }

      DispatchQueue.main.async {
        self._textFieldRootCI.text = String(data: data, encoding: .utf8) ?? ""
      }
    }).resume()
  }
  
  func _fetchPubKey() {
    let urlString = String("\(self._textFieldBaseUrl.text ?? url)/se/keys.do")
  
    CardKConfig.fetchKeys(urlString)
  }
  
  @objc func _textFieldDidEndEditing() {
    _fetchPubKey()
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc func _reloadTableView() {
    self.tableView.reloadData()
  }
  
  @objc func _pressedCleanButton() {
    ThreeDS2ViewController.logs.removeAllObjects()
    self.tableView.reloadData()
  }
  
  @objc func _pressedButton() {
    self._runSDK()
    self._registerOrder()
    
    _transactionManager.rootCI = _textFieldRootCI.text ?? "";
    _transactionManager.directoryServerId = _textFieldDirectoryServerId.text ?? "";

    let controller = CardKViewController();
    controller.cKitDelegate = self;
    
    let createdUiController = CardKViewController.create(self, controller: controller);
    
    let navController = UINavigationController(rootViewController: createdUiController)
    
    if #available(iOS 13.0, *) {
      self.present(navController, animated: true)
      return;
    }
    
    navController.modalPresentationStyle = .formSheet

    let closeBarButtonItem = UIBarButtonItem(
     title: "Close",
     style: .done,
     target: self,
     action: #selector(_close(sender:))
    )
    createdUiController.navigationItem.leftBarButtonItem = closeBarButtonItem
    self.present(navController, animated: true)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    _textFieldBaseUrl.frame = CGRect(x: 20, y: 10, width: self.view.bounds.width - 40, height: 50)
    _textFieldCost.frame = CGRect(x: 20, y: _textFieldBaseUrl.frame.maxY + 10, width: self.view.bounds.width - 40, height: 50)
    
    _textFieldUserName.frame = CGRect(x: 20, y: _textFieldCost.frame.maxY + 10, width: self.view.bounds.width / 2 - 30, height: 50)
    _textFieldPassword.frame = CGRect(x: _textFieldUserName.frame.maxX + 30, y: _textFieldCost.frame.maxY + 10, width: self.view.bounds.width / 2 - 40, height: 50)
    
    _textFieldDirectoryServerId.frame = CGRect(x: 20, y: _textFieldPassword.frame.maxY + 10, width: self.view.bounds.width - 40, height: 50)

    _textFieldRootCI.frame = CGRect(x: 20, y: _textFieldDirectoryServerId.frame.maxY + 10, width: self.view.bounds.width - 40, height: 50)

    _headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: _textFieldRootCI.frame.maxY + 20)
    
    self.tableView.tableHeaderView?.frame = _headerView.frame
    self.navigationController?.isNavigationBarHidden = false
    
    let doneButton = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(_pressedButton))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(_pressedCleanButton))
    
    self.setToolbarItems([cancelButton,spaceButton, doneButton], animated: false)
    self.navigationController?.isToolbarHidden = false
  }
  
  private func _runSDK() {
    url = _textFieldBaseUrl.text ?? url
    
    _requestParams.amount = _textFieldCost.text
    _requestParams.userName = _textFieldUserName.text
    _requestParams.password = _textFieldPassword.text
    _requestParams.returnUrl = "finish.html"
    _requestParams.email = "test@test.com"
    _requestParams.text = "DE DE"
    _requestParams.threeDSSDK = "true"
  }
  
  private func _registerOrder() {
    API.registerNewOrder(params: _requestParams) {(data, response) in
      DispatchQueue.main.async {
        self._setRegisterOrderLog(response: response)

        self._requestParams.orderId = data.orderId
        
        CardKConfig.shared.mdOrder = data.orderId ?? ""
      }
    }
  }
  
  private func _sePayment() {
    API.sePayment(params: _requestParams) {(data, response) in
      DispatchQueue.main.async {
        self._setSePaymentLog(response: response)

        guard let data = data else {
          self._transactionManager.close()
          return
        }
        
        self._requestParams.threeDSSDKKey = data.threeDSSDKKey
        self._requestParams.threeDSServerTransId = data.threeDSServerTransId
        self._transactionManager.pubKey = data.threeDSSDKKey ?? ""
        
        do {
          try self._transactionManager.initializeSdk()
          self._transactionManager.showProgressDialog()
          self._requestParams.authParams = try self._transactionManager.getAuthRequestParameters()
          self._sePaymentStep2()
        } catch {
          self._transactionManager.closeProgressDialog()
        }
      }
    }
  }

  private func _sePaymentStep2() {
    API.sePaymentStep2(params: _requestParams) {(data, response) in
      DispatchQueue.main.async {
        self._setSePaymentStep2Log(response: response)
        
        guard let data = data else {
          self._transactionManager.close()
          return
        }
           
        let _aRes = [
          "threeDSServerTransID": self._requestParams.threeDSServerTransId ?? "",
          "acsTransID": data.acsTransID ?? "",
          "acsReferenceNumber": data.acsReferenceNumber ?? "",
          "acsSignedContent": data.acsSignedContent ?? ""
        ]

        self._transactionManager.handleResponse(responseObject: _aRes)
      }
    }
  }
  
  func finishOrder() {
    API.finishOrder(params: self._requestParams) { (data, response) in
      self._setFinishOrderLog(response: response)
      API.fetchOrderStatus(params: self._requestParams) {(data, response) in
        self._setOrderStatusLog(response: response)
      }
    }
  }
  
  @objc func _close(sender:UIButton){
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
    
    let log = ThreeDS2ViewController.logs[indexPath.item] as! [String: String]
    
    cell.textLabel?.text = "\(log["title"] ?? "")"
    cell.accessoryType = .disclosureIndicator

    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ThreeDS2ViewController.logs.count
  }

  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let log = ThreeDS2ViewController.logs[indexPath.item] as! [String: String]
    
    let _reqResController = ReqResDetailsController()
    
    _reqResController.requestInfo = log["request"] ?? ""
    _reqResController.responseInfo = log["response"] ?? ""
  
    self.navigationController?.pushViewController(_reqResController, animated: true)
    
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension ThreeDS2ViewController: CardKDelegate {
  func didRemove(_ removedBindings: [CardKBinding]) {
    
  }
  
  func cardKPaymentView(_ paymentView: CardKPaymentView, didAuthorizePayment pKPayment: PKPayment) {
  
  }
  
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
    debugPrint(seToken)

    let alert = UIAlertController(title: "SeToken", message: "allowSaveCard = \(allowSaveBinding) \n isNewCard = \(isNewCard) \n seToken = \(seToken)", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    _requestParams.seToken = seToken
    
    self.dismiss(animated: true, completion: nil)
    _sePayment()
  }
  
  func bindingViewController(_ controller: CardKBindingViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
    debugPrint(seToken)

    let alert = UIAlertController(title: "SeToken", message: "allowSaveCard = \(allowSaveBinding) \n isNewCard = \(isNewCard) \n seToken = \(seToken)", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    _requestParams.seToken = seToken
    
    self.dismiss(animated: true, completion: nil)
    _sePayment()
  }
  
  func willShowPaymentView(_ paymentView: CardKApplePayButtonView) {
    let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
    let paymentItem = PKPaymentSummaryItem.init(label: "Box", amount: NSDecimalNumber(value: 0.1))
    let merchandId = "merchant.cardkit";
    paymentView.merchantId = merchandId
    paymentView.paymentRequest.currencyCode = "USD"
    paymentView.paymentRequest.countryCode = "US"
    paymentView.paymentRequest.merchantIdentifier = merchandId
    paymentView.paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
    paymentView.paymentRequest.supportedNetworks = paymentNetworks
    paymentView.paymentRequest.paymentSummaryItems = [paymentItem]
    paymentView.paymentButtonStyle = .black;
    paymentView.paymentButtonType = .buy;
  }
  
  func didLoad(_ controller: CardKViewController) {
    controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
    controller.purchaseButtonTitle = "Custom purchase button";

    controller.displayCardHolderField = true;
    controller.allowSaveBinding = true;
    controller.isSaveBinding = false;
  }
  
  func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {

  }
}

extension ThreeDS2ViewController {
  private func _setRegisterOrderLog(response: Data) {
    let params = self._requestParams
    let body = [
      "amount": params.amount ?? "",
      "userName": params.userName ?? "",
      "password": params.password ?? "",
      "returnUrl": params.returnUrl ?? "",
    ];
    
    self.addLog(title: "Register New Order",
                request: String(describing: Utils.jsonSerialization(data: body)), response:String(describing: Utils.jsonSerialization(data: response)))
 
    
    self._notificationCenter.post(name: Notification.Name("ReloadTable"), object: nil)
  }

  private func _setSePaymentLog(response: Data?) {
    let params = self._requestParams
    let body = [
      "seToken": params.seToken ?? "",
      "MDORDER": params.orderId ?? "",
      "userName": params.userName ?? "",
      "password": params.password ?? "",
      "TEXT": params.text ?? "",
      "threeDSSDK": params.threeDSSDK ?? "",
    ];
    
    if let response = response {
      self.addLog(title: "Payment", request: String(describing: Utils.jsonSerialization(data: body)), response: Utils.jsonSerialization(data: response))
    } else {
      self.addLog(title: "Payment", request: String(describing: Utils.jsonSerialization(data: body)), response: Utils.jsonSerialization(data: ["error": "Empty object"]))
    }

    self._notificationCenter.post(name: Notification.Name("ReloadTable"), object: nil)
  }
  
  private func _setSePaymentStep2Log(response: Data) {
    let params = self._requestParams
    let body = [
      "seToken": params.seToken ?? "",
      "MDORDER": params.orderId ?? "",
      "threeDSServerTransId": params.threeDSServerTransId ?? "",
      "userName": params.userName ?? "",
      "password": params.password ?? "",
      "TEXT": params.text ?? "",
      "threeDSSDK": params.threeDSSDK ?? "",
      "threeDSSDKEncData": params.authParams!.getDeviceData(),
      "threeDSSDKEphemPubKey":params.authParams!.getSDKEphemeralPublicKey(),
      "threeDSSDKAppId": params.authParams!.getSDKAppID(),
      "threeDSSDKTransId": params.authParams!.getSDKTransactionID()
    ];
    
    self.addLog(title: "Payment step 2", request: String(describing: Utils.jsonSerialization(data: body)), response: String(describing: Utils.jsonSerialization(data: response)))
    
    self._notificationCenter.post(name: Notification.Name("ReloadTable"), object: nil)
  }
  
  func _setFinishOrderLog(response: Data) {
    let params = self._requestParams
    let body = [
      "threeDSServerTransId": params.threeDSServerTransId ?? "",
      "userName": params.userName ?? "",
      "password": params.password ?? "",
    ];

    self.addLog(title: "Finish order", request: String(describing: Utils.jsonSerialization(data: body)), response: String(describing: Utils.jsonSerialization(data: response)), isReload: false)
  }
  
  func _setOrderStatusLog(response: Data) {
    let params = self._requestParams
    let body = [
      "orderId": params.orderId ?? "",
      "userName": params.userName ?? "",
      "password": params.password ?? ""
    ];

    self.addLog(title: "Fetch order status",
                           request: String(describing: Utils.jsonSerialization(data: body)),
                           response: String(describing: Utils.jsonSerialization(data: response)),
                           isReload: true)
  }
}
