//
//  ViewController.swift
//  SDKPaymentIntegration
//

import UIKit
import SDKPayment
import SDKForms
import ThreeDSSDK

class ViewController: UIViewController {

    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.accessibilityIdentifier = "Checkout"
        return button
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Here will be result"
        label.accessibilityIdentifier = "resultLabel"
        return label
    }()
    
    override func loadView() {
        super.loadView()
     
        view.backgroundColor = .white
        setupSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupSubviews() {
        view.addSubview(checkoutButton)
        view.addSubview(resultLabel)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                checkoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
                resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
        
        checkoutButton.addTarget(self, action: #selector(onCheckoutClick), for: .touchUpInside)
    }
    
    @objc
    private func onCheckoutClick() {
        guard let targetConfigString = ProcessInfo.processInfo.environment["paymentConfig"],
              let base64EncodedData = targetConfigString.data(using: .utf8),
              let data = Data(base64Encoded: base64EncodedData),
              let paymentConfig = try? JSONDecoder().decode(SDKPaymentConfig.self, from: data),
              let orderId = ProcessInfo.processInfo.environment["orderId"]
        else {
            print("There is no PaymentConfig for checkout")
            return
        }
        
        if let needsToLog = ProcessInfo.processInfo.environment["needsToLog"],
           let needsToLogValue = Bool(needsToLog),
           needsToLogValue {
            ThreeDSLogger.shared.setupLogUploaderConfigProvider(configProvider: self)
        }
        
        startChekout(
            orderId: orderId,
            paymentConfig: paymentConfig
        )
    }
    
    private func startChekout(
        orderId: String,
        paymentConfig: SDKPaymentConfig
    ) {
        _ = SdkPayment.initialize(
            sdkPaymentConfig: paymentConfig
        )
        
        SdkPayment.shared.checkoutWithBottomSheet(
            controller: self.navigationController!,
            mdOrder: orderId,
            callbackHandler: self
        )
    }
}

extension ViewController: ResultPaymentCallback {
    
    typealias T = PaymentResult
    
    func onResult(result: PaymentResult) {
        print(result)
        resultLabel.text = "\(result.isSuccess)"
    }
}

extension ViewController: LogUploaderConfigProvider {
    
    func provideConfig(sdkAppId: String?) -> ThreeDSSDK.LogUploaderConfig? {
        .sentry(url: "SentryUrl", key: "SentryKey")
    }
}
