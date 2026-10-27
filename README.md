# PAYRDR iOS SDK

Payment SDK for iOS: a ready-made payment form (card, saved cards, Apple Pay) and card data encryption for the payment gateway.

- **SDKPayment** — payment flow with the prebuilt UI. Recommended for most integrations.
- **SDKCore** — card validation and cryptogram (seToken) generation, for your own payment UI.

## Requirements

- iOS 12.0+
- Xcode 15+, Swift 5.9+
- Apps built for iOS 27 must use the UIScene life cycle (Apple requirement)

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/Radarpayments/ios-sdk
```

choose **Up to Next Major Version** starting from `3.1.0` and add the `SDKPayment` product (or `SDKCore` only).

In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Radarpayments/ios-sdk", from: "3.1.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [.product(name: "SDKPayment", package: "ios-sdk")]
    )
]
```

### XCFramework

Each [release](https://github.com/Radarpayments/ios-sdk/releases) has `SDKCore.zip` and `SDKPayment.zip` attached, each containing the XCFramework. Add both to the app target with **Embed & Sign**.

## Quick start

```swift
import SDKPayment

final class CheckoutViewController: UIViewController, ResultPaymentCallback {

    func pay(mdOrder: String) {
        _ = SdkPayment.initialize(
            sdkPaymentConfig: SDKPaymentConfig(
                baseURL: "https://<gateway-host>/payment",
                keyProviderUrl: "https://<gateway-host>/payment/se/keys.do"
            )
        )

        SdkPayment.shared.checkoutWithBottomSheet(
            controller: navigationController!,
            checkoutConfig: CheckoutConfig(id: .mdOrder(id: mdOrder)),
            callbackHandler: self
        )
    }

    func onResult(result: PaymentResult) {
        // result.isSuccess, result.exception:
        // SDKCancelledException when the user cancels,
        // SDKDeclinedException (message, actionCode, errorType) when the payment is declined
    }
}
```

The order (`mdOrder`) or session (`sessionId`) is registered by your backend; card data never reaches it.

## Migration from 3.0.x

3.1.0 merges the former `SDKForms` framework into `SDKPayment` and adds Swift Package Manager.

- Switch to Swift Package Manager (above), or replace the frameworks with the `SDKCore.zip` and `SDKPayment.zip` of
  the release. Remove `SDKForms` and `ThreeDSSDK` from the app target.
- Replace `import SDKForms` with `import SDKPayment`: `SDKException` and the other shared types are there now.
- `SdkForms`, `SDKConfigBuilder`, `PaymentConfigBuilder` and `ApplePayPaymentConfig` are no longer public. Pay with
  `SdkPayment.shared.checkoutWithBottomSheet`; to build your own payment UI, generate the cryptogram with `SDKCore`.
- A failed payment now comes with `result.exception`. A declined payment returns `SDKDeclinedException` with the
  gateway message (in the device language), `actionCode` and `errorType`. A payment cancelled by the user returns
  `SDKCancelledException`. If your code treated `exception == nil` as "not failed", check
  `result.isSuccess` instead.

## Documentation

Full integration guide: https://github.com/Radarpayments/mobile-sdk-doc/wiki

## License

[MIT](LICENSE.md) © BPC
