//
//  SampleCardKPaymentView.swift
//  SampleApp
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

import UIKit
import CardKit


class SampleCardKPaymentView: UIViewController {
  var buttons: [CardKPaymentView] = [];
  
  override func viewDidLoad() {
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.bindingCVCRequired = true;
    CardKConfig.shared.bindings = [];
    CardKConfig.shared.isTestMod = true;
    CardKConfig.shared.mdOrder = "mdOrder";
    CardKConfig.shared.mrBinApiURL = "https://mrbin.io/bins/display";
    CardKConfig.shared.mrBinURL = "https://mrbin.io/bins/";
    
    self.view.backgroundColor = CardKTheme.light().colorTableBackground;
    let buttonsCGRect = _getButtons();

    for buttonCGRect in buttonsCGRect {
      let cardKPaymentView = CardKPaymentView.init(delegate: self);
      cardKPaymentView.controller = self;
      self.view.addSubview(cardKPaymentView);
      cardKPaymentView.frame = buttonCGRect;
      cardKPaymentView.center.x = self.view.center.x;
      cardKPaymentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      buttons.append(cardKPaymentView);
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    let buttonsCGRect = _getButtons();

    for (index, button) in buttons.enumerated() {
      button.frame = buttonsCGRect[index];
      button.center.x = self.view.center.x;
      self.view.addSubview(button);
    }
  }
   
  func _getButtons() -> [CGRect] {
    let height = self.view.bounds.height;
    
    let buttonsCGRect = [
      CGRect(x: 0, y: height * 0.5 - 150, width: 200, height: 100),
      CGRect(x: 0, y: height * 0.5 - 50, width: 300, height: 30),
      CGRect(x: 0, y: height * 0.5 + 50, width: 350, height: 100),
      CGRect(x: 0, y: height * 0.5 + 150, width: self.view.bounds.width, height: 100),
    ];
    
    return buttonsCGRect;
  }
}

extension SampleCardKPaymentView: CardKDelegate {
  func didRemove(_ removedBindings: [CardKBinding]) {
    
  }
  
  func cardKPaymentView(_ paymentView: CardKPaymentView, didAuthorizePayment pKPayment: PKPayment) {
  
  }
  
//  func willShow(_ paymentView: CardKPaymentView) {
//    let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
//    let paymentItem = PKPaymentSummaryItem.init(label: "Box", amount: NSDecimalNumber(value: 0.1))
//    let merchandId = "merchant.test.applepay.id";
//    paymentView.merchantId = merchandId
//    paymentView.paymentRequest.currencyCode = "USD"
//    paymentView.paymentRequest.countryCode = "US"
//    paymentView.paymentRequest.merchantIdentifier = merchandId
//    paymentView.paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
//    paymentView.paymentRequest.supportedNetworks = paymentNetworks
//    paymentView.paymentRequest.paymentSummaryItems = [paymentItem]
//    paymentView.paymentButtonStyle = .black;
//    paymentView.paymentButtonType = .buy;
//
//    paymentView.cardPaybutton.backgroundColor = .white;
//    paymentView.cardPaybutton.setTitleColor(.black, for: .normal);
//    paymentView.cardPaybutton.setTitle("Custom title", for: .normal);
//  }
 
  func willShowPaymentView(_ paymentView: CardKApplePayButtonView) {
    let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
    let paymentItem = PKPaymentSummaryItem.init(label: "Box", amount: NSDecimalNumber(value: 0.1))
    let merchandId = "merchant.test.applepay.id";
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

    controller.allowSaveBinding = true;
    controller.isSaveBinding = false;
  }
  
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
  }
  
  func bindingViewController(_ controller: CardKBindingViewController, didCreateSeToken seToken: String, allowSaveBinding: Bool, isNewCard: Bool) {
  }
  
  func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {

  }
}
