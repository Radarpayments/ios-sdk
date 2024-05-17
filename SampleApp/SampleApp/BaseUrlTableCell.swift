//
//  BaseUrlTableCell.swift
//  SampleApp
//
//
//

import UIKit

final class BaseUrlTableCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.addTarget(self,
                            action: #selector(BaseUrlTableCell.textFieldDidChangeValue(_:)),
                            for: .editingChanged)
        
        return textField
    }()
    
    private var cellConfig: CellConfig!
    private weak var delegate: CellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func configure(config: CellConfig, delegate: CellDelegate?) {
        self.cellConfig = config
        self.delegate = delegate

        titleLabel.text = config.placeholder
        textField.placeholder = config.placeholder
        textField.text = config.value
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ]
        )
    }
    
    @objc
    private func textFieldDidChangeValue(_ textField: UITextField) {
        delegate?.valueDidChange(id: cellConfig.placeholder, value: textField.text ?? "")
    }
}
