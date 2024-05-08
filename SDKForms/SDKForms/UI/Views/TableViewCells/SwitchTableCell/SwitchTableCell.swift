//
//  SwitchTableCell.swift
//  SDKForms
//
// 
//

import UIKit

protocol SwitchTableCellDelegate: AnyObject {
    
    func switchDidChange(_ isOn: Bool)
}

final class SwitchTableCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeSetting.shared.colorLabel()
        
        return label
    }()
    
    private lazy var actionSwitch: UISwitch = {
        let actionSwitch = UISwitch()
        actionSwitch.isOn = false

        return actionSwitch
    }()
    
    private var model: SwitchTableModel?
    private weak var delegate: SwitchTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
        setupActionSwitch()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
        setupActionSwitch()
    }
    
    func bind(
        model: SwitchTableModel,
        delegate: SwitchTableCellDelegate?
    ) -> Self {
        self.model = model
        self.delegate = delegate
        titleLabel.text = model.title
        actionSwitch.isOn = model.isOn
        
        return self
    }
    
    private func setupActionSwitch() {
        actionSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc
    func switchChanged(actionSwitch: UISwitch) {
        delegate?.switchDidChange(actionSwitch.isOn)
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(titleLabel)
        contentView.addSubview(actionSwitch)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionSwitch.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: actionSwitch.centerYAnchor),
                
                actionSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                actionSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                actionSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ]
        )
    }
}
