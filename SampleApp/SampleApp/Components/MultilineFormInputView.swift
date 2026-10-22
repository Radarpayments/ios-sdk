//
//  MultilineFormInputView.swift
//  MyStore
//

import UIKit

class MultilineFormInputView: UIView {
    let titleLabel = UILabel()
    let textView = UITextView()
    let errorLabel = UILabel()

    private var baseTitle: String

    init(title: String, placeholder: String, defaultValue: String) {
        self.baseTitle = title
        super.init(frame: .zero)

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .adaptiveLabel

        textView.text = defaultValue.isEmpty ? "" : defaultValue
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .adaptiveSecondaryBackground
        textView.textColor = .adaptiveLabel
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.adaptiveSeparator.cgColor
        textView.layer.cornerRadius = 6
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)

        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            errorLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
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

    func showError(_ state: SimpleValidationState) {
        switch state {
        case .valid:
            errorLabel.isHidden = true
            errorLabel.text = ""
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.adaptiveSeparator.cgColor
        case .invalid:
            errorLabel.isHidden = false
            errorLabel.text = "Invalid value"
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.systemRed.cgColor
        case .empty:
            errorLabel.isHidden = false
            errorLabel.text = "This field is required"
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}
