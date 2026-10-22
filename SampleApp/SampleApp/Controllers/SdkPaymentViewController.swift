//
//  SdkPaymentViewController.swift
//  MyStore
//

import UIKit
import SDKPayment

private enum ApiVersion: Int, CaseIterable {
    case v1 = 0
    case v2 = 1

    var title: String {
        switch self {
        case .v1: return "API V1"
        case .v2: return "API V2"
        }
    }
}

struct PaymentFormData {
    // common properties
    var apiPaymentUrl: String = SDKPaymentDefaults.apiPaymentUrl
    var amount: String = SDKPaymentDefaults.amount
    var currency: String = SDKPaymentDefaults.currency
    var merchantCustomerId: String = SDKPaymentDefaults.merchantCustomerId

    // API V1
    var apiOrderUrl: String = SDKPaymentDefaults.apiOrderUrl
    var merchantUserName: String = SDKPaymentDefaults.merchantUserName
    var merchantPassword: String = SDKPaymentDefaults.merchantPassword
    var returnUrl: String = SDKPaymentDefaults.returnUrl
    var merchantOrderId: String = SDKPaymentDefaults.merchantOrderId

    // API V2
    var apiSessionUrl: String = SDKPaymentDefaults.apiSessionUrl
    var apiKey: String = SDKPaymentDefaults.apiKey
    var apiVersion: String = SDKPaymentDefaults.apiVersion
    var successUrl: String = SDKPaymentDefaults.successUrl
    var failureUrl: String = SDKPaymentDefaults.failureUrl
}

class SdkPaymentViewController: UIViewController {
    var orderId: String = ""
    var sessionId: String = ""

    private var formData = PaymentFormData()
    private var selectedApiVersion: ApiVersion = .v1

    private let formPersistence = FormPersistenceService.shared

    private var apiPaymentUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.apiPaymentUrl",
        defaultValue: SDKPaymentDefaults.apiPaymentUrl
    )
    private var amountConfig = FormFieldConfig(
        fieldKey: "sdkPayment.amount",
        defaultValue: SDKPaymentDefaults.amount
    )
    private var currencyConfig = FormFieldConfig(
        fieldKey: "sdkPayment.currency",
        defaultValue: SDKPaymentDefaults.currency
    )
    private var merchantCustomerIdConfig = FormFieldConfig(
        fieldKey: "sdkPayment.merchantCustomerId",
        defaultValue: SDKPaymentDefaults.merchantCustomerId
    )
    private var apiOrderUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.apiOrderUrl",
        defaultValue: SDKPaymentDefaults.apiOrderUrl
    )
    private var merchantUserNameConfig = FormFieldConfig(
        fieldKey: "sdkPayment.merchantUserName",
        defaultValue: SDKPaymentDefaults.merchantUserName
    )
    private var merchantPasswordConfig = FormFieldConfig(
        fieldKey: "sdkPayment.merchantPassword",
        defaultValue: SDKPaymentDefaults.merchantPassword
    )
    private var returnUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.returnUrl",
        defaultValue: SDKPaymentDefaults.returnUrl
    )
    private var merchantOrderIdConfig = FormFieldConfig(
        fieldKey: "sdkPayment.merchantOrderId",
        defaultValue: SDKPaymentDefaults.merchantOrderId
    )
    private var apiSessionUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.apiSessionUrl",
        defaultValue: SDKPaymentDefaults.apiSessionUrl
    )
    private var apiKeyConfig = FormFieldConfig(
        fieldKey: "sdkPayment.apiKey",
        defaultValue: SDKPaymentDefaults.apiKey
    )
    private var apiVersionConfig = FormFieldConfig(
        fieldKey: "sdkPayment.apiVersion",
        defaultValue: SDKPaymentDefaults.apiVersion
    )
    private var successUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.successUrl",
        defaultValue: SDKPaymentDefaults.successUrl
    )
    private var failureUrlConfig = FormFieldConfig(
        fieldKey: "sdkPayment.failureUrl",
        defaultValue: SDKPaymentDefaults.failureUrl
    )

    private let keyProviderPath: String = "/se/keys.do"

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var apiVersionSegmentedControl: UISegmentedControl!
    private var apiVersionLabel: UILabel!
    private var apiPaymentUrlInput: FormInputView!
    private var amountInput: FormInputView!
    private var currencyInput: FormInputView!
    private var merchantCustomerIdInput: FormInputView!
    private var apiSessionUrlInput: FormInputView!
    private var apiKeyInput: FormInputView!
    private var apiVersionInput: FormInputView!
    private var successUrlInput: FormInputView!
    private var failureUrlInput: FormInputView!
    private var apiOrderUrlInput: FormInputView!
    private var merchantUserNameInput: FormInputView!
    private var merchantPasswordInput: FormInputView!
    private var returnUrlInput: FormInputView!
    private var merchantOrderIdInput: FormInputView!
    private var apiConfigSection: CollapsibleSectionView!
    private var apiConfigContainer: UIView!
    private var apiConfigStackView: UIStackView!
    private var mainFieldsStackView: UIStackView!
    private var payButton: UIButton!
    private var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "SDK Payment"
        view.backgroundColor = .adaptiveBackground

        loadPersistedFormData()
        setupUI()
        setupConstraints()
        updateFieldVisibility()
    }

    private func loadPersistedFormData() {
        formData.apiPaymentUrl = formPersistence.value(for: apiPaymentUrlConfig)
        formData.amount = formPersistence.value(for: amountConfig)
        formData.currency = formPersistence.value(for: currencyConfig)
        formData.merchantCustomerId = formPersistence.value(for: merchantCustomerIdConfig)

        formData.apiOrderUrl = formPersistence.value(for: apiOrderUrlConfig)
        formData.merchantUserName = formPersistence.value(for: merchantUserNameConfig)
        formData.merchantPassword = formPersistence.value(for: merchantPasswordConfig)
        formData.returnUrl = formPersistence.value(for: returnUrlConfig)
        formData.merchantOrderId = formPersistence.value(for: merchantOrderIdConfig)

        formData.apiSessionUrl = formPersistence.value(for: apiSessionUrlConfig)
        formData.apiKey = formPersistence.value(for: apiKeyConfig)
        formData.apiVersion = formPersistence.value(for: apiVersionConfig)
        formData.successUrl = formPersistence.value(for: successUrlConfig)
        formData.failureUrl = formPersistence.value(for: failureUrlConfig)
    }

    private func setupUI() {
        let segmentTitles = ApiVersion.allCases.map { $0.title }
        apiVersionSegmentedControl = UISegmentedControl(items: segmentTitles)
        apiVersionSegmentedControl.selectedSegmentIndex = ApiVersion.v1.rawValue
        apiVersionSegmentedControl.addTarget(self, action: #selector(apiVersionChanged), for: .valueChanged)

        apiVersionLabel = UILabel()
        apiVersionLabel.text = selectedApiVersion.title
        apiVersionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        apiVersionLabel.textColor = .adaptiveLabel
        apiVersionLabel.numberOfLines = 0

        apiPaymentUrlInput = FormInputView(
            title: "API Payment URL",
            placeholder: "Enter API payment URL",
            defaultValue: formData.apiPaymentUrl,
            validator: { _ in .VALID }
        )

        amountInput = FormInputView(
            title: "Amount",
            placeholder: "Enter amount",
            defaultValue: formData.amount,
            validator: { _ in .VALID }
        )

        currencyInput = FormInputView(
            title: "Currency",
            placeholder: "Enter currency",
            defaultValue: formData.currency,
            validator: { _ in .VALID }
        )

        merchantCustomerIdInput = FormInputView(
            title: "Merchant Customer ID",
            placeholder: "Enter merchant customer ID",
            defaultValue: formData.merchantCustomerId,
            validator: { _ in .VALID }
        )

        // API V1 inputs
        apiOrderUrlInput = FormInputView(
            title: "Register Order URL",
            placeholder: "Enter URL for order registration",
            defaultValue: formData.apiOrderUrl,
            validator: { _ in .VALID }
        )

        merchantUserNameInput = FormInputView(
            title: "Merchant Username",
            placeholder: "Enter merchant username",
            defaultValue: formData.merchantUserName,
            validator: { _ in .VALID }
        )

        merchantPasswordInput = FormInputView(
            title: "Merchant Password",
            placeholder: "Enter merchant password",
            defaultValue: formData.merchantPassword,
            validator: { _ in .VALID }
        )

        returnUrlInput = FormInputView(
            title: "Return URL",
            placeholder: "Enter return URL",
            defaultValue: formData.returnUrl,
            validator: { _ in .VALID }
        )

        merchantOrderIdInput = FormInputView(
            title: "Merchant Order ID",
            placeholder: "Enter merchant order ID",
            defaultValue: formData.merchantOrderId,
            validator: { _ in .VALID }
        )

        // API V2 inputs
        apiSessionUrlInput = FormInputView(
            title: "Register Session URL",
            placeholder: "Enter URL for session registration",
            defaultValue: formData.apiSessionUrl,
            validator: { _ in .VALID }
        )

        apiKeyInput = FormInputView(
            title: "API Key",
            placeholder: "Enter API key",
            defaultValue: formData.apiKey,
            validator: { _ in .VALID }
        )

        apiVersionInput = FormInputView(
            title: "API Version",
            placeholder: "Enter API version",
            defaultValue: formData.apiVersion,
            validator: { _ in .VALID }
        )

        successUrlInput = FormInputView(
            title: "Success URL",
            placeholder: "Enter success URL",
            defaultValue: formData.successUrl,
            validator: { _ in .VALID }
        )

        failureUrlInput = FormInputView(
            title: "Failure URL",
            placeholder: "Enter failure URL",
            defaultValue: formData.failureUrl,
            validator: { _ in .VALID }
        )

        apiConfigContainer = UIView()
        apiConfigStackView = UIStackView(arrangedSubviews: [
            apiPaymentUrlInput,
            apiSessionUrlInput,
            apiKeyInput,
            apiVersionInput,
            successUrlInput,
            failureUrlInput,
            apiOrderUrlInput,
            merchantUserNameInput,
            merchantPasswordInput,
            returnUrlInput
        ])
        apiConfigStackView.axis = .vertical
        apiConfigStackView.spacing = 16
        apiConfigStackView.alignment = .fill
        apiConfigStackView.distribution = .fill
        apiConfigContainer.addSubview(apiConfigStackView)

        apiConfigSection = CollapsibleSectionView(
            title: "Additional Settings",
            contentView: apiConfigContainer,
            isCollapsed: true
        )

        mainFieldsStackView = UIStackView(arrangedSubviews: [
            merchantCustomerIdInput,
            merchantOrderIdInput,
            amountInput,
            currencyInput
        ])
        mainFieldsStackView.axis = .vertical
        mainFieldsStackView.spacing = 16
        mainFieldsStackView.alignment = .fill
        mainFieldsStackView.distribution = .fill

        payButton = UIButton(type: .system)
        payButton.backgroundColor = .systemGreen
        payButton.setTitle("Do Payment", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(payButtonClick), for: .touchUpInside)

        resultTextView = UITextView()
        resultTextView.font = .systemFont(ofSize: 14, weight: .regular)
        resultTextView.textColor = .adaptiveLabel
        resultTextView.backgroundColor = .adaptiveGrayBackground
        resultTextView.layer.cornerRadius = 8
        resultTextView.isEditable = false
        resultTextView.isScrollEnabled = false
        resultTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        resultTextView.text = ""
        resultTextView.isHidden = true

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(apiVersionSegmentedControl)
        contentView.addSubview(apiVersionLabel)
        contentView.addSubview(mainFieldsStackView)
        contentView.addSubview(apiConfigSection)
        contentView.addSubview(payButton)
        contentView.addSubview(resultTextView)

        apiPaymentUrlInput.textField.delegate = self
        amountInput.textField.delegate = self
        currencyInput.textField.delegate = self
        merchantCustomerIdInput.textField.delegate = self
        apiOrderUrlInput.textField.delegate = self
        merchantUserNameInput.textField.delegate = self
        merchantPasswordInput.textField.delegate = self
        returnUrlInput.textField.delegate = self
        merchantOrderIdInput.textField.delegate = self
        apiSessionUrlInput.textField.delegate = self
        apiKeyInput.textField.delegate = self
        apiVersionInput.textField.delegate = self
        successUrlInput.textField.delegate = self
        failureUrlInput.textField.delegate = self
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        apiVersionSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        apiVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        apiConfigSection.translatesAutoresizingMaskIntoConstraints = false
        apiConfigContainer.translatesAutoresizingMaskIntoConstraints = false
        apiConfigStackView.translatesAutoresizingMaskIntoConstraints = false
        mainFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        resultTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            apiVersionSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            apiVersionSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            apiVersionSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            apiVersionSegmentedControl.heightAnchor.constraint(equalToConstant: 32),

            apiVersionLabel.topAnchor.constraint(equalTo: apiVersionSegmentedControl.bottomAnchor, constant: 12),
            apiVersionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            apiVersionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            mainFieldsStackView.topAnchor.constraint(equalTo: apiVersionLabel.bottomAnchor, constant: 24),
            mainFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            apiConfigSection.topAnchor.constraint(equalTo: mainFieldsStackView.bottomAnchor, constant: 16),
            apiConfigSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            apiConfigSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            apiConfigStackView.topAnchor.constraint(equalTo: apiConfigContainer.topAnchor),
            apiConfigStackView.leadingAnchor.constraint(equalTo: apiConfigContainer.leadingAnchor),
            apiConfigStackView.trailingAnchor.constraint(equalTo: apiConfigContainer.trailingAnchor),
            apiConfigStackView.bottomAnchor.constraint(equalTo: apiConfigContainer.bottomAnchor),

            payButton.topAnchor.constraint(equalTo: apiConfigSection.bottomAnchor, constant: 32),
            payButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 50),

            resultTextView.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 16),
            resultTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    @objc
    private func apiVersionChanged() {
        guard let version = ApiVersion(rawValue: apiVersionSegmentedControl.selectedSegmentIndex) else {
            return
        }

        selectedApiVersion = version
        apiVersionLabel.text = selectedApiVersion.title

        updateFieldVisibility()
    }

    private func updateFieldVisibility() {
        let isV1 = selectedApiVersion == .v1
        let isV2 = selectedApiVersion == .v2

        apiPaymentUrlInput.isHidden = false
        merchantCustomerIdInput.isHidden = false
        amountInput.isHidden = false
        currencyInput.isHidden = false

        // API V1 specific in collapsible / main
        apiOrderUrlInput.isHidden = !isV1
        merchantUserNameInput.isHidden = !isV1
        merchantPasswordInput.isHidden = !isV1
        returnUrlInput.isHidden = !isV1
        merchantOrderIdInput.isHidden = !isV1

        // API V2 specific in collapsible section
        apiSessionUrlInput.isHidden = !isV2
        apiKeyInput.isHidden = !isV2
        apiVersionInput.isHidden = !isV2
        successUrlInput.isHidden = !isV2
        failureUrlInput.isHidden = !isV2

        view.layoutIfNeeded()
    }

    @objc
    private func payButtonClick() {
        formData.apiPaymentUrl = apiPaymentUrlInput.textField.text ?? ""
        formData.amount = amountInput.textField.text ?? ""
        formData.currency = currencyInput.textField.text ?? ""
        formData.merchantCustomerId = merchantCustomerIdInput.textField.text ?? ""

        formPersistence.set(formData.apiPaymentUrl, for: apiPaymentUrlConfig)
        formPersistence.set(formData.amount, for: amountConfig)
        formPersistence.set(formData.currency, for: currencyConfig)
        formPersistence.set(formData.merchantCustomerId, for: merchantCustomerIdConfig)

        switch selectedApiVersion {
        case .v1:
            formData.apiOrderUrl = apiOrderUrlInput.textField.text ?? ""
            formData.merchantUserName = merchantUserNameInput.textField.text ?? ""
            formData.merchantPassword = merchantPasswordInput.textField.text ?? ""
            formData.returnUrl = returnUrlInput.textField.text ?? ""
            formData.merchantOrderId = merchantOrderIdInput.textField.text ?? ""

            formPersistence.set(formData.apiOrderUrl, for: apiOrderUrlConfig)
            formPersistence.set(formData.merchantUserName, for: merchantUserNameConfig)
            formPersistence.set(formData.merchantPassword, for: merchantPasswordConfig)
            formPersistence.set(formData.returnUrl, for: returnUrlConfig)
            formPersistence.set(formData.merchantOrderId, for: merchantOrderIdConfig)

            OrderService.registerNewOrder(
                requestUrl: formData.apiOrderUrl,
                userName: formData.merchantUserName,
                password: formData.merchantPassword,
                returnUrl: formData.returnUrl,
                amount: formData.amount,
                clientId: formData.merchantCustomerId,
                orderId: formData.merchantOrderId
            ) { [weak self] orderId in
                guard let self else { return }

                self.orderId = orderId

                DispatchQueue.main.async {
                    self.checkout(checkoutConfig: CheckoutConfig(id: .mdOrder(id: orderId)))
                }
            }

        case .v2:
            formData.apiSessionUrl = apiSessionUrlInput.textField.text ?? ""
            formData.apiKey = apiKeyInput.textField.text ?? ""
            formData.apiVersion = apiVersionInput.textField.text ?? ""
            formData.successUrl = successUrlInput.textField.text ?? ""
            formData.failureUrl = failureUrlInput.textField.text ?? ""

            formPersistence.set(formData.apiSessionUrl, for: apiSessionUrlConfig)
            formPersistence.set(formData.apiKey, for: apiKeyConfig)
            formPersistence.set(formData.apiVersion, for: apiVersionConfig)
            formPersistence.set(formData.successUrl, for: successUrlConfig)
            formPersistence.set(formData.failureUrl, for: failureUrlConfig)

            SessionService.registerNewSession(
                requestUrl: formData.apiSessionUrl,
                apiKey: formData.apiKey,
                apiVersion: formData.apiVersion,
                successUrl: formData.successUrl,
                failureUrl: formData.failureUrl,
                amount: formData.amount,
                currency: formData.currency,
                merchantCustomerId: formData.merchantCustomerId
            ) { [weak self] sessionId in
                guard let self else { return }

                self.sessionId = sessionId

                DispatchQueue.main.async {
                    self.checkout(checkoutConfig: CheckoutConfig(id: .sessionId(id: sessionId)))
                }
            }
        }
    }

    private func checkout(checkoutConfig: CheckoutConfig) {
        _ = SdkPayment.initialize(
            sdkPaymentConfig: SDKPaymentConfig(
                baseURL: formData.apiPaymentUrl,
                keyProviderUrl: "\(formData.apiPaymentUrl)\(keyProviderPath)",
                applePaySettings: nil
            )
        )

        SdkPayment.shared.checkoutWithBottomSheet(
            controller: navigationController!,
            checkoutConfig: checkoutConfig,
            callbackHandler: self
        )
    }
}

extension SdkPaymentViewController: ResultPaymentCallback {

    typealias T = PaymentResult

    func onResult(result: PaymentResult) {
        var resultText = ""

        // To get result of payment we need to meet the requirements of protocol 'ResultPaymentCallback'
        // After the payment is completed we'll get 'PaymentResult'
        // This result contains 3 properties: isSuccess: Bool, mdOrder: String
        // and if it exists - exception: SDKException(message: String?, cause: Error?)
        if result.exception is SDKCancelledException {
            resultText = "⚠️ Action cancelled\n\nUser cancelled the payment"
        } else {
            resultText = result.isSuccess ? "✅ Payment successful" : "❌ Payment failed"
            resultText += "\n\nPayment ID: \(result.paymentId)"
            resultText += "\n\nException description: \(String(describing: result.exception))"
            resultText += "\n\nException message: \(result.exception?.message ?? "N/A")"
        }

        resultTextView.text = resultText
        resultTextView.isHidden = false

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            let rect = self.resultTextView.convert(self.resultTextView.bounds, to: self.scrollView)
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}

extension SdkPaymentViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""

        if textField == apiPaymentUrlInput.textField {
            formPersistence.set(text, for: apiPaymentUrlConfig)
        } else if textField == amountInput.textField {
            formPersistence.set(text, for: amountConfig)
        } else if textField == currencyInput.textField {
            formPersistence.set(text, for: currencyConfig)
        } else if textField == merchantCustomerIdInput.textField {
            formPersistence.set(text, for: merchantCustomerIdConfig)
        } else if textField == apiOrderUrlInput.textField {
            formPersistence.set(text, for: apiOrderUrlConfig)
        } else if textField == merchantUserNameInput.textField {
            formPersistence.set(text, for: merchantUserNameConfig)
        } else if textField == merchantPasswordInput.textField {
            formPersistence.set(text, for: merchantPasswordConfig)
        } else if textField == returnUrlInput.textField {
            formPersistence.set(text, for: returnUrlConfig)
        } else if textField == merchantOrderIdInput.textField {
            formPersistence.set(text, for: merchantOrderIdConfig)
        } else if textField == apiSessionUrlInput.textField {
            formPersistence.set(text, for: apiSessionUrlConfig)
        } else if textField == apiKeyInput.textField {
            formPersistence.set(text, for: apiKeyConfig)
        } else if textField == apiVersionInput.textField {
            formPersistence.set(text, for: apiVersionConfig)
        } else if textField == successUrlInput.textField {
            formPersistence.set(text, for: successUrlConfig)
        } else if textField == failureUrlInput.textField {
            formPersistence.set(text, for: failureUrlConfig)
        }
    }
}
