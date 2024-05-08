//
//  DividerTableHeader.swift
//  SDKForms
//
// 
//

import UIKit

final class DividerTableHeader: UITableViewHeaderFooterView {
    
    private lazy var leadingDivider: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeSetting.shared.colorSeparator()
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro15
        label.textColor = ThemeSetting.shared.colorSeparator()

        return label
    }()
    
    private lazy var trailingDivider: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeSetting.shared.colorSeparator()
        
        return view
    }()
    
    private var model: DividerTableHeaderModel?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
    }
    
    func bind(model: DividerTableHeaderModel) -> Self {
        self.model = model
        titleLabel.text = model.title

        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(leadingDivider)
        contentView.addSubview(titleLabel)
        contentView.addSubview(trailingDivider)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
                
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                leadingDivider.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                leadingDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                leadingDivider.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),
                leadingDivider.heightAnchor.constraint(equalToConstant: 0.5),
                
                trailingDivider.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                trailingDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                trailingDivider.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
                trailingDivider.heightAnchor.constraint(equalToConstant: 0.5)
            ]
        )
    }
}
