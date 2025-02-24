//
//  TextFieldView.swift
//  SDKForms
//
// 
//

import UIKit
import SDKCore

final class CardDataTextFieldView: UIView {

    private let MAX_CARD_EXPIRY_LENGTH = 4
    private let MAX_CARD_CVC_LENGTH = 3
    private let NUMBER_MAX_LENGTH = 19
    private let CARD_HOLDER_MAX_LENGTH = 30
    
    private var _isFilled = false
    private var _id = ""
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var dividerLine: UIView = {
        let view = UIView()

        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                leftImageView,
                textField
            ]
        )
        stack.axis = .horizontal
        stack.spacing = 8
        
        return stack
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro13
        label.textColor = ThemeSetting.shared.colorErrorLabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8

        return label
    }()

    private var config: CardDataTextFieldViewState?
    private var pattern: CardDataTextFieldStringPattern = .cardNumber
    private var textChangingHandler: ((String) -> Void)?
    
    private var cardLogoResolver = AssetsResolver()
    private var cardDataTextFormatter = CardDataTextFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupSubviews()
        setupLayout()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
        setupTextField()
    }
    
    func setState(_ config: CardDataTextFieldViewState) {
        self._id = config.id
        self.config = config
        self.pattern = config.pattern
        updateView()
    }
    
    private func updateCardLogo(withText text: String) {
        guard !(config?.hideleftImageView ?? true),
              let cardLogo = cardLogoResolver.resolveByPan(
                pan: text,
                preferLight: ThemeSetting.shared.getTheme() == .light
              )
        else {
            setLeftImage(nil)
            return
        }

        setLeftImage(UIImage(resource: ImageResource(name: cardLogo, bundle: .sdkFormsBundle)))
    }
    
    private func setLeftImage(_ image: UIImage?) {
        guard let image else {
            self.leftImageView.image = nil
            self.leftImageView.isHidden = true
            return
        }

        leftImageView.image = image
        leftImageView.isHidden = false
    }
    
    func setTextChangingHandler(_ handler: @escaping (String) -> Void) {
        textChangingHandler = handler
    }
    
    private func updateView() {        
        if !(config?.inputIsAvailable ?? true) || config?.isFilled ?? false {
            setFilled(true)
        }

        updateTextField()
        errorMessageLabel.text = config?.errorMessage
        dividerLine.backgroundColor = config?.errorMessage != ""
            ? ThemeSetting.shared.colorErrorLabel()
            : ThemeSetting.shared.colorSeparator()
        setNeedsLayout()
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        addSubview(dividerLine)
        addSubview(errorMessageLabel)
    }
    
    private func setupLayout() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate(
            [
                leftImageView.heightAnchor.constraint(equalToConstant: 36),
                leftImageView.widthAnchor.constraint(equalToConstant: 36),

                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                
                dividerLine.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                dividerLine.heightAnchor.constraint(equalToConstant: 1),
                dividerLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
                
                errorMessageLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 8),
                errorMessageLabel.leadingAnchor.constraint(equalTo: dividerLine.leadingAnchor),
                errorMessageLabel.trailingAnchor.constraint(equalTo: dividerLine.trailingAnchor)

            ]
        )
    }
    
    private func setupTextField() {
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func textDidChange(_ textField: UITextField) {
        errorMessageLabel.text = ""
        dividerLine.backgroundColor = ThemeSetting.shared.colorSeparator()

        textField.text = cardDataTextFormatter
            .modify(textField.text ?? "", forPattern: pattern)
        
        textChangingHandler?(textField.text ?? "")
        updateCardLogo(withText: textField.text ?? "")
    }
    
    private func updateTextField() {
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.menlo17,
            NSAttributedString.Key.foregroundColor: ThemeSetting.shared.colorPlaceholder()
        ]
        let attributtedPlaceholder = NSAttributedString(string: config?.placeholder ?? "", attributes: attributes)

        textField.attributedPlaceholder = attributtedPlaceholder
        textField.textColor = ThemeSetting.shared.colorLabel()
        textField.isSecureTextEntry = config?.isSecureInput ?? false
        textField.isUserInteractionEnabled = config?.inputIsAvailable ?? true
        
        switch pattern {
        case .cardHolder, .mandatoryField, .plain:
            textField.keyboardType = .default
        case .cardNumber, .cardExpiry, .cardCVC:
            textField.keyboardType = .numberPad
        case .phoneNumber:
            textField.keyboardType = .phonePad
        case .email:
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }

        if let text = config?.text {
            textField.text = ""
            textField.insertText(text)
        }
        
        textField.delegate = self
        textField.accessibilityIdentifier = config?.placeholder
    }
}

extension CardDataTextFieldView: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if newLength < textField.text?.count ?? .zero { return true }
        
        switch pattern {
        case .cardNumber:
            return (textField.text?.digitsOnly().count ?? .zero) < NUMBER_MAX_LENGTH
        case .cardExpiry:
            return (textField.text?.digitsOnly().count ?? .zero) < MAX_CARD_EXPIRY_LENGTH
        case .cardCVC:
            return (textField.text?.digitsOnly().count ?? .zero) < MAX_CARD_CVC_LENGTH
        case .cardHolder:
            return (textField.text?.count ?? .zero) < CARD_HOLDER_MAX_LENGTH
        case .mandatoryField, .phoneNumber, .email, .plain:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        config?.textFieldDoneButtonHandler?(self)
        return true
    }
}

extension CardDataTextFieldView: InputView {
    
    var id: String {
        _id
    }

    var isFilled: Bool {
        _isFilled
    }
    
    var value: String {
        textField.text ?? ""
    }
    
    func setActive(_ active: Bool) {
        active
            ? textField.becomeFirstResponder()
            : textField.endEditing(true)
    }
    
    func setFilled(_ filled: Bool) {
        _isFilled = filled
    }
}
