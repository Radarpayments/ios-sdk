//
//  ButtonTableCell.swift
//  SDKForms
//
// 
//

import UIKit

protocol ButtonTableCellDelegate: AnyObject {
    
    func clickOnActionButton()
}

final class ButtonTableCell: UITableViewCell {
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "actionButton"
        return button
    }()
    
    private var model: ButtonTableModel?
    private weak var delegate: ButtonTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
        setupActionButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
        setupActionButton()
    }
    
    func bind(
        model: ButtonTableModel,
        delegate:ButtonTableCellDelegate?
    ) -> Self {
        self.model = model
        self.delegate = delegate

        actionButton.setTitle(model.title, for: .normal)
        
        return self
    }
    
    private func setupActionButton() {
        actionButton.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        actionButton.backgroundColor = ThemeSetting.shared.colorButtonBackground()
        actionButton.setTitleColor(ThemeSetting.shared.colorButtonText(), for: .normal)
        actionButton.layer.cornerRadius = 8
    }
    
    @objc
    private func clickOnButton() {
        delegate?.clickOnActionButton()
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(actionButton)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                actionButton.heightAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
}
