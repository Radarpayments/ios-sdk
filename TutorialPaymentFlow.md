# Integration PaymentFlow

First you need to go through point 1, 2 of [SDK integration instructions](Tutorial.md)

## CardKPaymentFlowController

|      Property name       |          Data type           | Defaul value | Optional | Description                                      |
| :----------------------: | :--------------------------: | :----------: | :------: | ------------------------------------------------ |
|     cardKPaymentView     |       CardKPaymentView       |     nil      |    NO    | Setting the Apple pay/New card buttons           |
|           url            |            String            |     nil      |    NO    | URL of a backend                                 |
|       primaryColor       |           UIColor            | .systemBlue  |   Yes    | Color of button/checkboxs/cancel in 3dssdk forms |
|   textDoneButtonColor    |           UIColor            |    .white    |   Yes    | Text color of a button                           |
|    allowedCardScaner     |             BOOL             |    false     |   Yes    | Allow an user use CardIO                         |
|         bindings         |        [CardKBinding]        |      -       |    No    | Array of bindings                                |
|       headerLabel        |            String            |      ""      |   Yes    | label in 3dssdk form                             |
| cardKPaymentFlowDelegate | id<CardKPaymentFlowDelegate> |     nil      |   YES    | Payment flow delegate                            |

## CardKPaymentError

| Property name | Data type | Defaul value | Optional | Description             |
| :-----------: | :-------: | :----------: | :------: | ----------------------- |
|    message    | NSString  |     nil      |   YES    | Message with error text |

## CardKPaymentFlowDelegate

`- (void)didFinishPaymentFlow:(NSDictionary *) paymentInfo;` - it is called when payment flow finish success/unsuccess; <br />
`- (void)didErrorPaymentFlow:(CardKPaymentError *) paymentError;` - is called when payment flow finish with error; <br />
`- (void)didCancelPaymentFlow;` - is called when an user cancel payment flow; <br />
`- (void)scanCardRequest:(CardKViewController *)controller` - is called when an user want to scan a physical card; <br />

## implementation PaymentFlowController

1. Import CardKit `import CardKit`
2. Init CardKitPaymentFlowController

```swift
  _paymentFlowController = CardKPaymentFlowController();
  _paymentFlowController.cardKPaymentFlowDelegate = self;
```

3. Fill the CardKConfig (You can read the exemple [here](README.md))
4. Need register an order and set parameters in a CardKPaymentFlowController instance.

```swift
  let paymentRequest = PKPaymentRequest();
  paymentRequest.currencyCode = "RUB";
  paymentRequest.countryCode = "RU";
  paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
  paymentRequest.supportedNetworks = [.visa, .masterCard];

  let cardPayButton = UIButton();
  cardPayButton.backgroundColor = .systemBlue;
  cardPayButton.setTitleColor(.white, for: .normal)
  cardPayButton.setTitle("Custom title", for: .normal)

  let cardKPaymentView = CardKPaymentView();
  cardKPaymentView.merchantId = "merchant.cardkit";
  cardKPaymentView.paymentRequest = paymentRequest;
  cardKPaymentView.paymentButtonStyle = .black;
  cardKPaymentView.paymentButtonType = .buy;
  cardKPaymentView.cardPaybutton = cardPayButton

  self._paymentFlowController.url = "https://web.rbsdev.com/soyuzpayment";
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
```

5. Implement delegate's functions

```swift
extension PaymentFlowController: CardKPaymentFlowDelegate {
  func didFinishPaymentFlow(_ paymentInfo: [AnyHashable : Any]!) {
    Log.i(object: self, message: "didFinishPaymentFlow")
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
```
