//
//  ViewController.swift
//  SampleApp
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

import UIKit
import CardKit
import ThreeDSSDK
import CardKitPayment
import CardKitCore

struct Section {
  let title: String?
  let items: [SectionItem]
}

struct SectionItem {
  let title: String
  let kind: Kind
  let isShowChevron: Bool
  let language: String
  
  enum Kind {
    case version
    case navLightTheme
    case navLightThemeWithoutApplePay
    case navNewCardWithoutSaveCard
    case navNewCardWithoutCardholder
    case navDarkTheme
    case navSystemTheme
    case language
    case paymentView
    case threeDS
    case threeDSCustomColors
    case editMode
    case paymentFlow3ds
    case paymentFlowOTP
    case paymentFlowSSP
    case paymentFlowMSP
    case paymentFlowWV
    case paymentFlowTwoValidCerts
    case paymentFlowThreeValidCerts
    case paymentFlowTwoValidCertsWithoutRootCert
    case paymentFlowInvalidCert
  }
}

class SampleAppCardIO: NSObject, CardIOViewDelegate {
  weak var cardKController: CardKViewController? = nil
  
  func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
    if let info = cardInfo {
      cardKController?.setCardNumber(info.cardNumber, holderName: info.cardholderName, expirationDate: nil, cvc: nil, bindingId: nil)
    }
    cardIOView?.removeFromSuperview()
  }
}


class ViewController: UITableViewController {
  var sampleAppCardIO: SampleAppCardIO? = nil
  
  let publicKey = """
        -----BEGIN PUBLIC KEY-----
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAws0r6I8emCsURXfuQcU2c9mwUlOiDjuCZ/f+EdadA4vq/kYt3w6kC5TUW97Fm/HTikkHd0bt8wJvOzz3T0O4so+vBaC0xjE8JuU1eCd+zUX/plw1REVVii1RNh9gMWW1fRNu6KDNSZyfftY2BTcP1dbE1itpXMGUPW+TOk3U9WP4vf7pL/xIHxCsHzb0zgmwShm3D46w7dPW+HO3PEHakSWV9bInkchOvh/vJBiRw6iadAjtNJ4+EkgNjHwZJDuo/0bQV+r9jeOe+O1aXLYK/s1UjRs5T4uGeIzmdLUKnu4eTOQ16P6BHWAjyqPnXliYIKfi+FjZxyWEAlYUq+CRqQIDAQAB-----END PUBLIC KEY-----
  """
  
  var allowSaveBinding = true
  var isSaveBinding = false
  var displayCardholderField = true
  
  @objc func _close(sender:UIButton){
    self.navigationController?.dismiss(animated: true, completion: nil)
  }

  func _setDefaultParams() {
    allowSaveBinding = true
    isSaveBinding = false
    displayCardholderField = true
  }
  
  func _openLightUINavigation() {
    Logger.add(Log());
    
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = self._fetchBindingCards();
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.pubKey = publicKey;
    CardKConfig.shared.displayApplyPayButton = true;
    
    let controller = CardKViewController();
    controller.cKitDelegate = self
    
    _presentController(controller: controller);
  }
  
  func _openLightUINavigationWithoutApplePay() {
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.displayApplyPayButton = false;
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = self._fetchBindingCards();
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.pubKey = publicKey;
    
    let controller = CardKViewController();
    controller.cKitDelegate = self
    
    _presentController(controller: controller);
  }
  
  func _openNewCardFormWithoutSaveCard() {
    allowSaveBinding = false;
    
    CardKConfig.shared.bindings = self._fetchBindingCards();
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.bindingCVCRequired = false;
    CardKConfig.shared.displayApplyPayButton = true;
    CardKConfig.shared.pubKey = publicKey;
    
    
    let controller = CardKViewController();
    controller.cKitDelegate = self

    _presentController(controller: controller);
  }
  
  func _openNewCardFormWithoutCardholder() {
    displayCardholderField = false;
    isSaveBinding = true;
    
    CardKConfig.shared.bindings = [];
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.displayApplyPayButton = true;
    
    let controller = CardKViewController();
    controller.cKitDelegate = self

    _presentController(controller: controller);
  }
  
  
  func _openEditBindingsMode() {
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = self._fetchBindingCards();
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = true;
    CardKConfig.shared.bindingCVCRequired = false;
    CardKConfig.shared.displayApplyPayButton = true;
    CardKConfig.shared.pubKey = publicKey;
    let controller = CardKViewController();
    controller.cKitDelegate = self
    _presentController(controller: controller);
  }

  func _openDarkUINavigation() {
    CardKConfig.shared.theme = CardKTheme.dark();
    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = [];
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    CardKConfig.shared.bindingsSectionTitle = "Your cards";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.displayApplyPayButton = true;

    let controller = CardKViewController();
    controller.cKitDelegate = self
    _presentController(controller: controller);
  }

  func _openSystemUINavigation() {
    
    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system();
    } else {
      CardKConfig.shared.theme = CardKTheme.default();
    };

    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = [];
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.isEditBindingListMode = false;
    CardKConfig.shared.displayApplyPayButton = true;

    let controller = CardKViewController();
    controller.cKitDelegate = self
    _presentController(controller: controller);
  }
  
  func _openWitchChooseLanguage(language: String) {
      CardKConfig.shared.language = language;
      CardKConfig.shared.theme = CardKTheme.light()
      CardKConfig.shared.bindingCVCRequired = true;
      CardKConfig.shared.bindings = self._fetchBindingCards();
      CardKConfig.shared.isTestMod = true;
      CardKConfig.shared.mdOrder = "mdOrder";
      CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
      CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
      CardKConfig.shared.bindingsSectionTitle = "Your cards";
      CardKConfig.shared.displayApplyPayButton = true;
    
      let controller = CardKViewController();
      controller.cKitDelegate = self
      _presentController(controller: controller);
  }
  
  func _openPaymentView() {
    let controller = SampleCardKPaymentView();
  
    self.navigationController?.pushViewController(controller, animated: true)
  }
    
  func _open3DSView() {
    let controller = ThreeDS2ViewController(style: .grouped, useCustomTheme: false);

    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func _open3DSViewCustom() {
    let controller = ThreeDS2ViewController(style: .grouped, useCustomTheme: true);
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func _openPaymentFlow(amount: String) {
    let paymentFlowController = PaymentFlowController();
    paymentFlowController.amount = amount;
    self.navigationController?.pushViewController(paymentFlowController, animated: true)
  }
  
  func _openPaymentFlow3ds(amount: String) {
    let paymentFlowController = PaymentFlowController();
    paymentFlowController.amount = amount;
    paymentFlowController.use3ds2sdk = false;
    self.navigationController?.pushViewController(paymentFlowController, animated: true)
  }
  
  func _version() {}
  
  func _callFunctionByKindOfButton(kind: SectionItem.Kind, language: String) {
    _setDefaultParams();

    switch kind {
      case .version: _version()
      case .navLightTheme: _openLightUINavigation()
      case .editMode: _openEditBindingsMode()
      case .navLightThemeWithoutApplePay: _openLightUINavigationWithoutApplePay()
      case .navNewCardWithoutSaveCard: _openNewCardFormWithoutSaveCard()
      case .navNewCardWithoutCardholder: _openNewCardFormWithoutCardholder()
      case .navDarkTheme: _openDarkUINavigation()
      case .navSystemTheme: _openSystemUINavigation()
      case .language: _openWitchChooseLanguage(language: language)
      case .paymentView: _openPaymentView()
      case .threeDS: _open3DSView()
      case .threeDSCustomColors: _open3DSViewCustom()
      case .paymentFlow3ds: _openPaymentFlow3ds(amount: "2000")
      case .paymentFlowOTP: _openPaymentFlow(amount: "2000")
      case .paymentFlowSSP: _openPaymentFlow(amount: "111")
      case .paymentFlowMSP: _openPaymentFlow(amount: "222")
      case .paymentFlowWV: _openPaymentFlow(amount: "333")
      case .paymentFlowTwoValidCerts: _openPaymentFlow(amount: "444")
      case .paymentFlowThreeValidCerts: _openPaymentFlow(amount: "555")
      case .paymentFlowTwoValidCertsWithoutRootCert: _openPaymentFlow(amount: "666")
      case .paymentFlowInvalidCert: _openPaymentFlow(amount: "777")
    }
  }

  var sections: [Section] = [
    Section(title: "Versions", items: [
      SectionItem(title: "CardKit: v\(CardKConfig.getVersion())", kind: .version, isShowChevron: false, language: ""),
      SectionItem(title: "CardKitCore: v0.0.20", kind: .version, isShowChevron: false, language: ""),
      SectionItem(title: "3DSSDK: v\(Ecom3DS2Service().getVersion())", kind: .version, isShowChevron: false, language: ""),
    ]),
    
    Section(title: "Navigation", items: [
      SectionItem(title: "Light theme with bindings", kind: .navLightTheme, isShowChevron: true, language: ""),
      SectionItem(title: "Light theme with edit mode", kind: .editMode, isShowChevron: true, language: ""),
      SectionItem(title: "Light theme without apple pay button", kind: .navLightThemeWithoutApplePay, isShowChevron: true, language: ""),
      SectionItem(title: "Dark theme", kind: .navDarkTheme, isShowChevron: true, language: ""),
      SectionItem(title: "System theme", kind: .navSystemTheme, isShowChevron: true, language: ""),
      SectionItem(title: "The New Card form without save card", kind: .navNewCardWithoutSaveCard, isShowChevron: true, language: ""),
      SectionItem(title: "The New Card form without card holder", kind: .navNewCardWithoutCardholder, isShowChevron: true, language: "")
    ]),
    
    Section(title: "CardKPaymentView", items: [
      SectionItem(title: "Apple Pay", kind: .paymentView, isShowChevron: true, language: ""),
    ]),
    
    Section(title: "Payment Flow", items: [
      SectionItem(title: "Run 3ds1 (amount: 2000)", kind: .paymentFlow3ds, isShowChevron: true, language: ""),
      SectionItem(title: "One time passcode (amount: 2000)", kind: .paymentFlowOTP, isShowChevron: true, language: ""),
      SectionItem(title: "Single Select (amount: 111)", kind: .paymentFlowSSP, isShowChevron: true, language: ""),
      SectionItem(title: "Multi-Select (amount: 222)", kind: .paymentFlowMSP, isShowChevron: true, language: ""),
      SectionItem(title: "WebView (amount: 333)", kind: .paymentFlowWV, isShowChevron: true, language: ""),
      SectionItem(title: "Two valid certs (amount: 444)", kind: .paymentFlowTwoValidCerts, isShowChevron: true, language: ""),
      SectionItem(title: "Three valid certs (amount: 555)", kind: .paymentFlowThreeValidCerts, isShowChevron: true, language: ""),
      SectionItem(title: "Two valid certs without roots (amount: 666)", kind: .paymentFlowTwoValidCertsWithoutRootCert, isShowChevron: true, language: ""),
      SectionItem(title: "One invalid cert (amount: 777)", kind: .paymentFlowInvalidCert, isShowChevron: true, language: "")
    ]),
    
    Section(title: "ThreeDSSample", items: [
      SectionItem(title: "ThreeDS Sample with default theme", kind: .threeDS, isShowChevron: true, language: ""),
      SectionItem(title: "ThreeDS Sample with custom theme", kind: .threeDSCustomColors, isShowChevron: true, language: ""),
    ]),
    
    
    Section(title: "Localization", items: [
      SectionItem(title: "English - en", kind: .language, isShowChevron: true, language: "en"),
      SectionItem(title: "Russian - ru", kind: .language, isShowChevron: true, language: "ru"),
      SectionItem(title: "German - de", kind: .language, isShowChevron: true, language: "de"),
      SectionItem(title: "French - fr", kind: .language, isShowChevron: true, language: "fr"),
      SectionItem(title: "Spanish - es", kind: .language, isShowChevron: true, language: "es"),
      SectionItem(title: "Ukrainian - uk", kind: .language, isShowChevron: true, language: "uk"),
    ]),
  ]

  func _presentController(controller: CardKViewController) {
    let createdUiController = CardKViewController.create(self, controller: controller);
    
    
    let navController = UINavigationController(rootViewController: createdUiController)
    
    if #available(iOS 13.0, *) {
      navController.modalPresentationStyle = .overCurrentContext;
      self.present(navController, animated: false)
      return;
    }
    
    navController.modalPresentationStyle = .overCurrentContext
    self.present(navController, animated: false)
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Examples"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    tableView.cellLayoutMarginsFollowReadableWidth = true;
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].items.count;
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
    let item = sections[indexPath.section].items[indexPath.item];
    cell.textLabel?.text = item.title
    cell.accessoryType = item.isShowChevron ? .disclosureIndicator : .none
    cell.selectionStyle = item.isShowChevron ? .default : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = self.sections[indexPath.section].items[indexPath.item];
    
    _callFunctionByKindOfButton(kind: item.kind, language: item.language);
    if item.isShowChevron {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func _readJSONFile() -> NSData? {
    let path = Bundle.main.path(forResource: "bindings", ofType: "json");
    return NSData.init(contentsOfFile: path ?? "");
  }

  
  func _fetchBindingCards() -> [CardKBinding] {
    let data = self._readJSONFile();
    
    if (data == nil) {
      return []
    }
    
    do {
      let responseDictionary: NSDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! NSDictionary
        
      let bindingItems = responseDictionary["bindingItems"] as! [Dictionary<String,AnyObject>]

      var bindings = [CardKBinding]();

      for binding in bindingItems {
        let cardKBinding = CardKBinding();
        let labelString: String = binding["label"] as! String;
        let label = labelString.components(separatedBy: " ");

        cardKBinding.bindingId = binding["id"] as! String;
        cardKBinding.paymentSystem = binding["paymentSystem"] as! String;
        cardKBinding.cardNumber = label[0];
        cardKBinding.expireDate = label[1];
        bindings.append(cardKBinding);
      }
      
      return bindings;
    } catch {
        print("error writing JSON: \(error)")
      
      return []
    }
  }
  
  func _showAlert(_ controller: UIViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
    let alert = UIAlertController(title: "SeToken", message: "allowSaveCard = \(allowSaveBinding) \n isNewCard = \(isNewCard) \n seToken = \(seToken)", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    controller.present(alert, animated: true)
  }
}

extension ViewController: CardKDelegate {
  func didRemove(_ removedBindings: [CardKBinding]) {
    let alert = UIAlertController(title: "Removed bindings", message: "bindings = \(removedBindings)", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    navigationController?.present(alert, animated: true)
  }
  
  func cardKPaymentView(_ paymentView: CardKPaymentView, didAuthorizePayment pKPayment: PKPayment) {
    
  }
  
  func willShowPaymentView(_ paymentView: CardKApplePayButtonView) {
    let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
    let paymentItem = PKPaymentSummaryItem.init(label: "Box", amount: NSDecimalNumber(value: 0.1))
    let merchandId = "merchant.test.applepay.id"
    paymentView.merchantId = merchandId
    paymentView.paymentRequest.currencyCode = "USD"
    paymentView.paymentRequest.countryCode = "US"
    paymentView.paymentRequest.merchantIdentifier = merchandId
    paymentView.paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
    paymentView.paymentRequest.supportedNetworks = paymentNetworks
    paymentView.paymentRequest.paymentSummaryItems = [paymentItem]
    paymentView.paymentButtonStyle = .whiteOutline;
  }
  
  
  func didLoad(_ controller: CardKViewController) {
    controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
    controller.allowSaveBinding = allowSaveBinding;
    controller.isSaveBinding = isSaveBinding;
  }
  
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
    debugPrint(seToken)
    
    self._showAlert(controller, didCreateSeToken: seToken, allowSaveBinding: allowSaveBinding, isNewCard: isNewCard)
  }
  
  func bindingViewController(_ controller: CardKBindingViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
    debugPrint(seToken)
    
    self._showAlert(controller, didCreateSeToken: seToken, allowSaveBinding: allowSaveBinding, isNewCard: isNewCard)
  }
  
  func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {
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

class Log: LogInterface {
  override func log(with class: AnyClass, tag: String, message: String, exception: Error?) {
    print("------");
    print("Example ovveride log");
    print("Class name - '\(String(describing: `class`))'")
    print("Tag - '\(tag)'");
    print("Message - '\(message)'");
    print("Exception - '\(String(describing: exception?.localizedDescription))'");
    print("------");
  }
}
