//
//  ViewController.swift
//  SampleApp
//
//
//

// For build app you need download ThreeDSSDK from the link
// https://github.com/Radarpayments/ios-sdk/releases
// And you need save ThreeDSSDK.xcframework to path "../Frameworks/ThreeDSSDK.xcframework"
import UIKit
import SDKForms
import SDKPayment
import ThreeDSSDK
import SDKCore

class ViewController: UIViewController {
    
    private lazy var cellConfigs: [CellConfig] = []
    
    private lazy var tableView: UITableView = {
        let scrollView = UITableView()

        return scrollView
    }()
    
    private lazy var payOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("Pay Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(payOrderClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var paySessionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("Pay Session", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(paySessionClick), for: .touchUpInside)
        
        return button
    }()
    
    private var baseUrl  = ""
    private var login    = ""
    private var password = ""
    private var amount   = ""
    
    private var orderId  = ""
    private var sessionId = ""
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        tableView.reloadData()
    }
    
    private func setupView() {
        navigationItem.title = "SampleApp"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(payOrderButton)
        view.addSubview(paySessionButton)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                payOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                payOrderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                payOrderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                payOrderButton.heightAnchor.constraint(equalToConstant: 48),
                
                paySessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
                paySessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                paySessionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                paySessionButton.heightAnchor.constraint(equalToConstant: 48),
                
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseUrlTableCell.self, forCellReuseIdentifier: "baseUrlCell")
        tableView.register(LoginTableCell.self, forCellReuseIdentifier: "loginCell")
        tableView.register(PasswordTableCell.self, forCellReuseIdentifier: "passwordCell")
        tableView.register(AmountTableCell.self, forCellReuseIdentifier: "amountCell")
        
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
    }
    
    @objc
    private func payOrderClick() {
        // You don't need to use .registerNewOrder()
        // This method needs only for creating order for SDKPayment in the SampleApp
        OrderCreator.registerNewOrder(baseUrl: baseUrl,
                                      amount: amount,
                                      userName: login,
                                      password: password) { [weak self] orderId in
            guard let self else { return }
            
            self.orderId = orderId
            
            DispatchQueue.main.async {
                // After creating order in an application we can start payment with SDKPayment
                self.checkout(orderId: self.orderId)
            }
        }
    }
    
    @objc
    private func paySessionClick() {
        OrderCreator.registerNewSession(baseUrl: baseUrl,
                                        amount: amount) { [weak self] sessionId in
            guard let self else { return }
            
            self.sessionId = sessionId
            
            DispatchQueue.main.async {
                self.checkout(sessionId: sessionId)
            }
        }
    }
    
    private func prepareData() {
        let configs = [
            CellConfig(placeholder: "baseUrl", value: ""),
            CellConfig(placeholder: "login", value: ""),
            CellConfig(placeholder: "password", value: ""),
            CellConfig(placeholder: "amount", value: "")
        ]
        
        configs.forEach { config in
            if let value = UserDefaults.standard.value(forKey: config.placeholder) as? String {
                cellConfigs.append(CellConfig(placeholder: config.placeholder, value: value))
                
                switch config.placeholder {
                case "baseUrl": baseUrl = value
                case "login": login = value
                case "password": password = value
                case "amount": amount = value
                default: break
                }
            } else {
                cellConfigs.append(config)
            }
        }
    }
    
    // MARK: - Start of payment
    private func checkout(orderId: String) {
        // For uploading logs you need to setup `LogUploadingConfigProvider` for ThreeDSLogger
        ThreeDSLogger.shared.setupLogUploaderConfigProvider(configProvider: self)

        // To begin checkout, first of all - we need to configure SDKPaymentConfig
        // For example:
        let paymentConfig = SDKPaymentConfig(
            baseURL: baseUrl,
            use3DSConfig: .noUse3ds2sdk,
            keyProviderUrl: "\(baseUrl)/se/keys.do",
            applePaySettings: nil
        )
        
        // The second step - to initialize object SdkPayment
        // For example:
        _ = SdkPayment.initialize(sdkPaymentConfig: paymentConfig)
        
        // And the third step - we need to call method 'checkoutWithBottomSheet' on the 'shared' object
        SdkPayment.shared.checkoutWithBottomSheet(
            controller: navigationController!,
            checkoutConfig: CheckoutConfig(id: .mdOrder(id: orderId)),
            callbackHandler: self
        )
    }
    
    private func checkout(sessionId: String) {
        // For uploading logs you need to setup `LogUploadingConfigProvider` for ThreeDSLogger
        ThreeDSLogger.shared.setupLogUploaderConfigProvider(configProvider: self)

        // To begin checkout, first of all - we need to configure SDKPaymentConfig
        // For example:
        let paymentConfig = SDKPaymentConfig(
            baseURL: baseUrl,
            use3DSConfig: .noUse3ds2sdk,
            keyProviderUrl: "\(baseUrl)/se/keys.do",
            applePaySettings: nil
        )
        
        // The second step - to initialize object SdkPayment
        // For example:
        _ = SdkPayment.initialize(sdkPaymentConfig: paymentConfig)
        
        // And the third step - we need to call method 'checkoutWithBottomSheet' on the 'shared' object
        SdkPayment.shared.checkoutWithBottomSheet(
            controller: navigationController!,
            checkoutConfig: CheckoutConfig(id: .sessionId(id: sessionId)),
            callbackHandler: self)
    }
    
    
}

extension ViewController: ResultPaymentCallback {

    typealias T = PaymentResult

    func onResult(result: PaymentResult) {
        // To get result of payment we need to meet the requirements of protocol 'ResultPaymentCallback'
        // After the payment is completed we'll get 'PaymentResult'
        // This result contains 3 properties: isSuccess: Bool, mdOrder: String
        // and if it exists - exception: SDKException(message: String?, cause: Error?)
        let alert = UIAlertController(
            title: "Checkout result",
            message: "Success: \(result.isSuccess),\n PaymentId: \(result.paymentId),\n Exception: \(result.exception?.message)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cellConfigs.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfig = cellConfigs[indexPath.row]
        
        switch cellConfig.placeholder {
        case "baseUrl":
            let cell = tableView.dequeueReusableCell(withIdentifier: "baseUrlCell", for: indexPath) as? BaseUrlTableCell
            cell?.configure(config: cellConfig, delegate: self)
            
            return cell ?? UITableViewCell()
            
        case "login":
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath) as? LoginTableCell
            cell?.configure(config: cellConfig, delegate: self)
            
            return cell ?? UITableViewCell()
            
        case "password":
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as? PasswordTableCell
            cell?.configure(config: cellConfig, delegate: self)
            
            return cell ?? UITableViewCell()
            
        case "amount":
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell", for: indexPath) as? AmountTableCell
            cell?.configure(config: cellConfig, delegate: self)
            
            return cell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 85 }
}

extension ViewController: CellDelegate {
    func valueDidChange(id: String, value: String) {
        UserDefaults.standard.setValue(value, forKey: id)
        
        switch id {
        case "baseUrl": baseUrl = value
        case "login": login = value
        case "password": password = value
        case "amount": amount = value
        default: break
        }
    }
}

extension ViewController: LogUploaderConfigProvider {
    
    func provideConfig(sdkAppId: String?) -> ThreeDSSDK.LogUploaderConfig? {
        .sentry(url: "SentryURL", key: "SentryKey")
    }
}
