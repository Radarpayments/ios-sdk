//
//  FormInputView.swift
//  MyStore
//

import SDKCore
import UIKit

class FormInputView: UIView {
    let titleLabel = UILabel()
    let textField = UITextField()
    let errorLabel = UILabel()

    private let validator: (String) -> ValidationResult
    private var baseTitle: String

    init(title: String, placeholder: String, defaultValue: String, validator: @escaping (String) -> ValidationResult) {
        self.validator = validator
        self.baseTitle = title
        super.init(frame: .zero)

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .adaptiveLabel

        textField.placeholder = placeholder
        textField.text = defaultValue
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none

        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(errorLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRequired(_ isRequired: Bool) {
        titleLabel.text = isRequired ? "\(baseTitle) *" : baseTitle
    }
    
    func showError(_ result: ValidationResult) {
        let textIsEmpty = textField.text?.isEmpty ?? true
        
        // Check if result is VALID using helper function
        if !isValidationResultValid(result) {
            // Not valid - determine if empty or invalid
            if textIsEmpty {
                // Empty case
                errorLabel.isHidden = false
                errorLabel.text = "This field is required"
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
                textField.layer.cornerRadius = 5
            } else {
                // Invalid case
                errorLabel.isHidden = false
                errorLabel.text = "Invalid value"
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemRed.cgColor
                textField.layer.cornerRadius = 5
            }
        } else {
            // Valid case
            errorLabel.isHidden = true
            errorLabel.text = ""
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
    }
    
    // Overloaded method for simple validation states
    func showError(_ state: SimpleValidationState) {
        switch state {
        case .valid:
            errorLabel.isHidden = true
            errorLabel.text = ""
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        case .invalid:
            errorLabel.isHidden = false
            errorLabel.text = "Invalid value"
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            textField.layer.cornerRadius = 5
        case .empty:
            errorLabel.isHidden = false
            errorLabel.text = "This field is required"
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            textField.layer.cornerRadius = 5
        }
    }
}
