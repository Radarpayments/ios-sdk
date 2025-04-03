//
//  PaymentsMethodsTableCell.swift
//  SDKForms
//

import UIKit

final class PaymentsMethodsTableCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeSetting.shared.colorLabel()
        label.font = .systemBold15
        
        return label
    }()
    
    private var model: PaymentsMethodsTableModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
    }
    
    func bind(model: PaymentsMethodsTableModel) -> Self {
        self.model = model
        titleLabel.text = model.title
        accessoryType = .disclosureIndicator
        accessibilityIdentifier = model.title
        
        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
        )
    }
}
