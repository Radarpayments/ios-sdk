//
//  SdkCoreViewController.swift
//  MyStore
//

import SDKCore
import UIKit

class SdkCoreViewController: UIViewController {
    private let tokenGenerationService = TokenGenerationService()
    private let formValidator = FormValidator()
    private let formPersistence = FormPersistenceService.shared

    // Persistent configurations for each form field
    private var cardNumberConfig = FormFieldConfig(
        fieldKey: "sdkCore.cardNumber",
        defaultValue: SDKCoreDefaults.cardNumber
    )
    private var cardExpiryConfig = FormFieldConfig(
        fieldKey: "sdkCore.cardExpiry",
        defaultValue: SDKCoreDefaults.cardExpiry
    )
    private var cardCodeConfig = FormFieldConfig(
        fieldKey: "sdkCore.cardCode",
        defaultValue: SDKCoreDefaults.cardCode
    )
    private var cardHolderConfig = FormFieldConfig(
        fieldKey: "sdkCore.cardHolder",
        defaultValue: SDKCoreDefaults.cardHolder
    )
    private var storedPaymentMethodIdConfig = FormFieldConfig(
        fieldKey: "sdkCore.storedPaymentMethodId",
        defaultValue: SDKCoreDefaults.storedPaymentMethodId
    )
    private var mdOrderConfig = FormFieldConfig(
        fieldKey: "sdkCore.mdOrder",
        defaultValue: SDKCoreDefaults.mdOrder
    )
    private var bindingIdConfig = FormFieldConfig(
        fieldKey: "sdkCore.bindingId",
        defaultValue: SDKCoreDefaults.bindingId
    )
    private var publicKeyConfig = FormFieldConfig(
        fieldKey: "sdkCore.publicKey",
        defaultValue: SDKCoreDefaults.publicKey
    )

    private var formData = TokenFormData(
        cardNumber: "",
        cardExpiry: "",
        cardCode: "",
        cardHolder: "",
        storedPaymentMethodId: "",
        mdOrder: "",
        bindingId: "",
        publicKey: ""
    )

    private var selectedTokenType: TokenType = .card

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var tokenTypeSegmentedControl: UISegmentedControl!
    private var tokenTypeLabel: UILabel!
    private var cardNumberInput: FormInputView!
    private var cardExpiryInput: FormInputView!
    private var cardCodeInput: FormInputView!
    private var cardHolderInput: FormInputView!
    private var storedPaymentMethodIdInput: FormInputView!
    private var mdOrderInput: FormInputView!
    private var bindingIdInput: FormInputView!
    private var publicKeyInput: MultilineFormInputView!
    private var publicKeySection: CollapsibleSectionView!
    private var generateButton: UIButton!
    private var resultTextView: UITextView!

    // Dynamic constraints
    private var cardExpiryTopConstraint: NSLayoutConstraint!
    private var cardCodeTopConstraint: NSLayoutConstraint!
    private var cardCodeLeadingConstraint: NSLayoutConstraint!
    private var cardCodeWidthConstraint: NSLayoutConstraint!
    private var cardCodeTrailingConstraint: NSLayoutConstraint!
    private var cardHolderTopConstraint: NSLayoutConstraint!
    private var storedPaymentMethodIdTopConstraint: NSLayoutConstraint!
    private var mdOrderTopConstraint: NSLayoutConstraint!
    private var bindingIdTopConstraint: NSLayoutConstraint!
    private var publicKeySectionTopConstraint: NSLayoutConstraint!
    private var generateButtonTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "SDK Core"
        view.backgroundColor = .adaptiveBackground

        loadPersistedFormData()
        setupUI()
        setupConstraints()
        updateFieldVisibility()
        updateRequiredFieldIndicators()
    }

    private func loadPersistedFormData() {
        formData.cardNumber = formPersistence.value(for: cardNumberConfig)
        formData.cardExpiry = formPersistence.value(for: cardExpiryConfig)
        formData.cardCode = formPersistence.value(for: cardCodeConfig)
        formData.cardHolder = formPersistence.value(for: cardHolderConfig)
        formData.storedPaymentMethodId = formPersistence.value(for: storedPaymentMethodIdConfig)
        formData.mdOrder = formPersistence.value(for: mdOrderConfig)
        formData.bindingId = formPersistence.value(for: bindingIdConfig)
        formData.publicKey = formPersistence.value(for: publicKeyConfig)
    }

    private func setupUI() {
        let shortLabels = TokenType.allCases.map { shortLabel(for: $0) }
        tokenTypeSegmentedControl = UISegmentedControl(items: shortLabels)
        tokenTypeSegmentedControl.selectedSegmentIndex = 0
        tokenTypeSegmentedControl.addTarget(self, action: #selector(tokenTypeChanged), for: .valueChanged)
        tokenTypeSegmentedControl.apportionsSegmentWidthsByContent = false

        tokenTypeLabel = UILabel()
        tokenTypeLabel.text = selectedTokenType.rawValue
        tokenTypeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tokenTypeLabel.textColor = .adaptiveLabel
        tokenTypeLabel.numberOfLines = 0

        cardNumberInput = FormInputView(
            title: "Card Number (PAN)",
            placeholder: "Enter card number",
            defaultValue: formData.cardNumber,
            validator: { [weak self] text in
                guard let self = self else { return .VALID }
                return self.formValidator.validateCardNumber(text)
            }
        )

        cardExpiryInput = FormInputView(
            title: "Expiry (MM/YY)",
            placeholder: "MM/YY",
            defaultValue: formData.cardExpiry,
            validator: { [weak self] text in
                guard let self = self else { return .VALID }
                return self.formValidator.validateCardExpiry(text)
            }
        )

        cardCodeInput = FormInputView(
            title: "CVC",
            placeholder: "Enter CVC",
            defaultValue: formData.cardCode,
            validator: { [weak self] text in
                guard let self = self else { return .VALID }
                return self.formValidator.validateCardCode(text)
            }
        )

        cardHolderInput = FormInputView(
            title: "Cardholder Name",
            placeholder: "Enter cardholder name",
            defaultValue: formData.cardHolder,
            validator: { [weak self] text in
                guard let self = self else { return .VALID }
                return self.formValidator.validateCardHolder(text)
            }
        )

        storedPaymentMethodIdInput = FormInputView(
            title: "Stored Payment Method ID",
            placeholder: "pm_...",
            defaultValue: formData.storedPaymentMethodId,
            validator: { _ in .VALID }
        )

        mdOrderInput = FormInputView(
            title: "MD Order",
            placeholder: "Enter MD Order",
            defaultValue: formData.mdOrder,
            validator: { _ in .VALID }
        )

        bindingIdInput = FormInputView(
            title: "Binding ID",
            placeholder: "Enter Binding ID",
            defaultValue: formData.bindingId,
            validator: { _ in .VALID }
        )

        publicKeyInput = MultilineFormInputView(
            title: "Public Key",
            placeholder: "Enter public key",
            defaultValue: formData.publicKey
        )

        publicKeySection = CollapsibleSectionView(
            title: "Additional Settings",
            contentView: publicKeyInput,
            isCollapsed: true
        )

        generateButton = UIButton(type: .system)
        generateButton.backgroundColor = .systemGreen
        generateButton.setTitle("Generate Token", for: .normal)
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.layer.cornerRadius = 8
        generateButton.addTarget(self, action: #selector(generateToken), for: .touchUpInside)

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
        contentView.addSubview(tokenTypeSegmentedControl)
        contentView.addSubview(tokenTypeLabel)
        contentView.addSubview(cardNumberInput)
        contentView.addSubview(cardExpiryInput)
        contentView.addSubview(cardCodeInput)
        contentView.addSubview(cardHolderInput)
        contentView.addSubview(storedPaymentMethodIdInput)
        contentView.addSubview(mdOrderInput)
        contentView.addSubview(bindingIdInput)
        contentView.addSubview(publicKeySection)
        contentView.addSubview(generateButton)
        contentView.addSubview(resultTextView)

        cardNumberInput.textField.delegate = self
        cardExpiryInput.textField.delegate = self
        cardCodeInput.textField.delegate = self
        cardHolderInput.textField.delegate = self
        storedPaymentMethodIdInput.textField.delegate = self
        mdOrderInput.textField.delegate = self
        bindingIdInput.textField.delegate = self
        publicKeyInput.textView.delegate = self

        // Format expiry input
        cardExpiryInput.textField.addTarget(self, action: #selector(expiryFieldChanged), for: .editingChanged)
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        tokenTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tokenTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumberInput.translatesAutoresizingMaskIntoConstraints = false
        cardExpiryInput.translatesAutoresizingMaskIntoConstraints = false
        cardCodeInput.translatesAutoresizingMaskIntoConstraints = false
        cardHolderInput.translatesAutoresizingMaskIntoConstraints = false
        storedPaymentMethodIdInput.translatesAutoresizingMaskIntoConstraints = false
        mdOrderInput.translatesAutoresizingMaskIntoConstraints = false
        bindingIdInput.translatesAutoresizingMaskIntoConstraints = false
        publicKeySection.translatesAutoresizingMaskIntoConstraints = false
        generateButton.translatesAutoresizingMaskIntoConstraints = false
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

            tokenTypeSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            tokenTypeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tokenTypeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tokenTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 32),

            tokenTypeLabel.topAnchor.constraint(equalTo: tokenTypeSegmentedControl.bottomAnchor, constant: 12),
            tokenTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tokenTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            cardNumberInput.topAnchor.constraint(equalTo: tokenTypeLabel.bottomAnchor, constant: 24),
            cardNumberInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardNumberInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            cardExpiryInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardExpiryInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.48, constant: -20),

            cardCodeInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            cardHolderInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardHolderInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            storedPaymentMethodIdInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storedPaymentMethodIdInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            mdOrderInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mdOrderInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            bindingIdInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bindingIdInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            publicKeySection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publicKeySection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            generateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            generateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            generateButton.heightAnchor.constraint(equalToConstant: 50),

            resultTextView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 16),
            resultTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        cardExpiryTopConstraint = cardExpiryInput.topAnchor.constraint(
            equalTo: cardNumberInput.bottomAnchor,
            constant: 16
        )
        cardCodeTopConstraint = cardCodeInput.topAnchor.constraint(
            equalTo: cardNumberInput.bottomAnchor,
            constant: 16
        )
        cardCodeLeadingConstraint = cardCodeInput.leadingAnchor.constraint(
            equalTo: cardExpiryInput.trailingAnchor,
            constant: 8
        )
        cardCodeWidthConstraint = cardCodeInput.widthAnchor.constraint(equalTo: cardExpiryInput.widthAnchor)
        cardCodeTrailingConstraint = cardCodeInput.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -16
        )
        cardHolderTopConstraint = cardHolderInput.topAnchor.constraint(
            equalTo: cardExpiryInput.bottomAnchor,
            constant: 16
        )
        storedPaymentMethodIdTopConstraint = storedPaymentMethodIdInput.topAnchor.constraint(
            equalTo: cardHolderInput.bottomAnchor,
            constant: 16
        )
        mdOrderTopConstraint = mdOrderInput.topAnchor.constraint(
            equalTo: storedPaymentMethodIdInput.bottomAnchor,
            constant: 16
        )
        bindingIdTopConstraint = bindingIdInput.topAnchor.constraint(
            equalTo: mdOrderInput.bottomAnchor,
            constant: 16
        )
        publicKeySectionTopConstraint = publicKeySection.topAnchor.constraint(
            equalTo: bindingIdInput.bottomAnchor,
            constant: 16
        )
        generateButtonTopConstraint = generateButton.topAnchor.constraint(
            equalTo: publicKeySection.bottomAnchor,
            constant: 32
        )
    }

    @objc private func tokenTypeChanged() {
        selectedTokenType = TokenType.allCases[tokenTypeSegmentedControl.selectedSegmentIndex]
        tokenTypeLabel.text = selectedTokenType.rawValue
        updateFieldVisibility()
        updateRequiredFieldIndicators()
    }

    private func shortLabel(for tokenType: TokenType) -> String {
        switch tokenType {
        case .card:
            return "Card"
        case .cardInstant:
            return "Instant"
        case .binding:
            return "Binding"
        case .bindingInstant:
            return "Bind Inst"
        case .newPaymentMethod:
            return "New PM"
        case .storedPaymentMethod:
            return "Stored"
        }
    }

    @objc private func expiryFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }

        let formatted = formatExpiry(text)

        if formatted != text {
            textField.text = formatted
        }
    }

    private func formatExpiry(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }

        if digits.count <= 2 {
            return digits
        } else if digits.count <= 4 {
            let index = digits.index(digits.startIndex, offsetBy: 2)
            return "\(digits[..<index])/\(digits[index...])"
        } else {
            let index = digits.index(digits.startIndex, offsetBy: 2)
            let index2 = digits.index(digits.startIndex, offsetBy: 4)
            return "\(digits[..<index])/\(digits[index..<index2])"
        }
    }

    private func updateFieldVisibility() {
        let isCard = selectedTokenType == .card
        || selectedTokenType == .cardInstant
        || selectedTokenType == .newPaymentMethod
        let isBinding = selectedTokenType == .binding || selectedTokenType == .bindingInstant
        let isStored = selectedTokenType == .storedPaymentMethod

        cardNumberInput.isHidden = !isCard
        cardExpiryInput.isHidden = !isCard
        cardHolderInput.isHidden = !isCard
        storedPaymentMethodIdInput.isHidden = !isStored
        mdOrderInput.isHidden = !(selectedTokenType == .card || selectedTokenType == .binding)
        bindingIdInput.isHidden = !isBinding
        // CVC is required for all except some cases - show for all
        cardCodeInput.isHidden = false
        updateConstraints()
    }

    private func updateRequiredFieldIndicators() {
        cardNumberInput.setRequired(false)
        cardExpiryInput.setRequired(false)
        cardCodeInput.setRequired(false)
        cardHolderInput.setRequired(false)
        storedPaymentMethodIdInput.setRequired(false)
        mdOrderInput.setRequired(false)
        bindingIdInput.setRequired(false)
        publicKeyInput.setRequired(false)

        switch selectedTokenType {
        case .card:
            cardNumberInput.setRequired(true)
            cardExpiryInput.setRequired(true)
            cardCodeInput.setRequired(true)
            mdOrderInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardHolder is optional

        case .cardInstant:
            cardNumberInput.setRequired(true)
            cardExpiryInput.setRequired(true)
            cardCodeInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardHolder is optional

        case .binding:
            bindingIdInput.setRequired(true)
            mdOrderInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardCode is optional

        case .bindingInstant:
            bindingIdInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardCode is optional

        case .newPaymentMethod:
            cardNumberInput.setRequired(true)
            cardExpiryInput.setRequired(true)
            cardCodeInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardHolder is optional

        case .storedPaymentMethod:
            storedPaymentMethodIdInput.setRequired(true)
            publicKeyInput.setRequired(true)
            // cardCode is optional
        }
    }

    private func updateConstraints() {
        cardExpiryTopConstraint.isActive = false
        cardCodeTopConstraint.isActive = false
        cardCodeLeadingConstraint.isActive = false
        cardCodeWidthConstraint.isActive = false
        cardCodeTrailingConstraint.isActive = false
        cardHolderTopConstraint.isActive = false
        storedPaymentMethodIdTopConstraint.isActive = false
        mdOrderTopConstraint.isActive = false
        bindingIdTopConstraint.isActive = false
        publicKeySectionTopConstraint.isActive = false
        generateButtonTopConstraint.isActive = false

        var lastVisibleView: UIView = cardNumberInput.isHidden ? tokenTypeLabel : cardNumberInput
        let topSpacing: CGFloat = cardNumberInput.isHidden ? 24 : 16

        if !cardExpiryInput.isHidden {
            cardExpiryTopConstraint = cardExpiryInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: topSpacing
            )
            cardExpiryTopConstraint.isActive = true
            cardCodeTopConstraint = cardCodeInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: topSpacing
            )
            cardCodeLeadingConstraint = cardCodeInput.leadingAnchor.constraint(
                equalTo: cardExpiryInput.trailingAnchor,
                constant: 8
            )
            cardCodeWidthConstraint = cardCodeInput.widthAnchor.constraint(equalTo: cardExpiryInput.widthAnchor)
            cardCodeTopConstraint.isActive = true
            cardCodeLeadingConstraint.isActive = true
            cardCodeWidthConstraint.isActive = true

            lastVisibleView = cardExpiryInput
        } else {
            cardCodeTopConstraint = cardCodeInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: topSpacing
            )
            cardCodeLeadingConstraint = cardCodeInput.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            )
            cardCodeTrailingConstraint = cardCodeInput.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            )
            cardCodeTopConstraint.isActive = true
            cardCodeLeadingConstraint.isActive = true
            cardCodeTrailingConstraint.isActive = true

            lastVisibleView = cardCodeInput
        }

        if !cardHolderInput.isHidden {
            cardHolderTopConstraint = cardHolderInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: 16
            )
            cardHolderTopConstraint.isActive = true
            lastVisibleView = cardHolderInput
        }

        if !storedPaymentMethodIdInput.isHidden {
            storedPaymentMethodIdTopConstraint = storedPaymentMethodIdInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: 16
            )
            storedPaymentMethodIdTopConstraint.isActive = true
            lastVisibleView = storedPaymentMethodIdInput
        }

        if !mdOrderInput.isHidden {
            mdOrderTopConstraint = mdOrderInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: 16
            )
            mdOrderTopConstraint.isActive = true
            lastVisibleView = mdOrderInput
        }

        if !bindingIdInput.isHidden {
            bindingIdTopConstraint = bindingIdInput.topAnchor.constraint(
                equalTo: lastVisibleView.bottomAnchor,
                constant: 16
            )
            bindingIdTopConstraint.isActive = true
            lastVisibleView = bindingIdInput
        }

        publicKeySectionTopConstraint = publicKeySection.topAnchor.constraint(
            equalTo: lastVisibleView.bottomAnchor,
            constant: 16
        )
        publicKeySectionTopConstraint.isActive = true

        generateButtonTopConstraint.isActive = false
        generateButtonTopConstraint = generateButton.topAnchor.constraint(
            equalTo: publicKeySection.bottomAnchor,
            constant: 32
        )
        generateButtonTopConstraint.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func generateToken() {
        updateFormDataFromInputs()

        let validationResult = formValidator.validate(type: selectedTokenType, formData: formData)

        showValidationErrors(validationResult: validationResult)

        guard validationResult.isValid else {
            return
        }

        let tokenResult = tokenGenerationService.generateToken(type: selectedTokenType, formData: formData)

        handleTokenResult(tokenResult: tokenResult)
    }

    private func updateFormDataFromInputs() {
        formData.cardNumber = cardNumberInput.textField.text ?? ""
        formData.cardExpiry = cardExpiryInput.textField.text ?? ""
        formData.cardCode = cardCodeInput.textField.text ?? ""
        formData.cardHolder = cardHolderInput.textField.text ?? ""
        formData.storedPaymentMethodId = storedPaymentMethodIdInput.textField.text ?? ""
        formData.mdOrder = mdOrderInput.textField.text ?? ""
        formData.bindingId = bindingIdInput.textField.text ?? ""
        formData.publicKey = publicKeyInput.textView.text ?? ""

        formPersistence.set(formData.cardNumber, for: cardNumberConfig)
        formPersistence.set(formData.cardExpiry, for: cardExpiryConfig)
        formPersistence.set(formData.cardCode, for: cardCodeConfig)
        formPersistence.set(formData.cardHolder, for: cardHolderConfig)
        formPersistence.set(formData.storedPaymentMethodId, for: storedPaymentMethodIdConfig)
        formPersistence.set(formData.mdOrder, for: mdOrderConfig)
        formPersistence.set(formData.bindingId, for: bindingIdConfig)
        formPersistence.set(formData.publicKey, for: publicKeyConfig)
    }

    private func showValidationErrors(validationResult: FormValidationResult) {
        cardNumberInput.showError(validationResult.cardNumber)
        cardExpiryInput.showError(validationResult.cardExpiry)
        cardCodeInput.showError(validationResult.cardCode)
        cardHolderInput.showError(validationResult.cardHolder)

        switch selectedTokenType {
        case .card, .cardInstant, .newPaymentMethod:
            if selectedTokenType == .card && formData.mdOrder.isEmpty {
                mdOrderInput.showError(.invalid)
            } else {
                mdOrderInput.showError(.valid)
            }

        case .binding, .bindingInstant:
            if formData.bindingId.isEmpty {
                bindingIdInput.showError(.invalid)
            } else {
                bindingIdInput.showError(.valid)
            }

            if selectedTokenType == .binding && formData.mdOrder.isEmpty {
                mdOrderInput.showError(.invalid)
            } else {
                mdOrderInput.showError(.valid)
            }

        case .storedPaymentMethod:
            if formData.storedPaymentMethodId.isEmpty {
                storedPaymentMethodIdInput.showError(.invalid)
            } else {
                storedPaymentMethodIdInput.showError(.valid)
            }
        }

        if formData.publicKey.isEmpty {
            publicKeyInput.showError(.invalid)
        } else {
            publicKeyInput.showError(.valid)
        }
    }

    private func handleTokenResult(tokenResult: TokenResult) {
        var resultText = ""

        if let token = tokenResult.token, !token.isEmpty {
            resultText = "✅ Token generated successfully:\n\n\(token)"
        } else if !tokenResult.errors.isEmpty {
            resultText = "❌ Token generation failed:\n\n"
            let errors = tokenResult.errors.map { "  • \($0.key): \($0.value)" }.joined(separator: "\n")
            resultText += errors
        } else {
            resultText = "❌ Unknown error occurred"
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

extension SdkCoreViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""

        if textField == cardNumberInput.textField {
            let result = formValidator.validateCardNumber(text)
            cardNumberInput.showError(result)
            formPersistence.set(text, for: cardNumberConfig)
        } else if textField == cardExpiryInput.textField {
            let result = formValidator.validateCardExpiry(text)
            cardExpiryInput.showError(result)
            formPersistence.set(text, for: cardExpiryConfig)
        } else if textField == cardCodeInput.textField {
            let result = formValidator.validateCardCode(text)
            cardCodeInput.showError(result)
            formPersistence.set(text, for: cardCodeConfig)
        } else if textField == cardHolderInput.textField {
            let result = formValidator.validateCardHolder(text)
            cardHolderInput.showError(result)
            formPersistence.set(text, for: cardHolderConfig)
        } else if textField == storedPaymentMethodIdInput.textField {
            formPersistence.set(text, for: storedPaymentMethodIdConfig)
        } else if textField == mdOrderInput.textField {
            formPersistence.set(text, for: mdOrderConfig)
        } else if textField == bindingIdInput.textField {
            formPersistence.set(text, for: bindingIdConfig)
        }
    }
}

extension SdkCoreViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text ?? ""

        if textView == publicKeyInput.textView {
            formPersistence.set(text, for: publicKeyConfig)
        }
    }
}
