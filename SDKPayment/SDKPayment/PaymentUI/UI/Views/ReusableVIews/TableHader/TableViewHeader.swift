//
//  TableViewHeader.swift
//  SDKPayment
//
// 
//

import UIKit

final class TableViewHeader: UITableViewHeaderFooterView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeSetting.shared.colorLabel()
        label.font = .systemBold20
        
        return label
    }()
    
    private var model: TableViewHeaderModel?
    
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
    
    func bind(model: TableViewHeaderModel) -> Self {
        self.model = model
        titleLabel.text = model.title
        
        return self
    }
    
    private func setupSubviews() {
        applyBackgroundAppearance()
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ]
        )
    }
    
    private func applyBackgroundAppearance() {
        let color = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = color
        if #available(iOS 15.0, *) {
            var configuration = UIBackgroundConfiguration.listPlainHeaderFooter()
            configuration.backgroundColor = color
            backgroundConfiguration = configuration
        } else {
            let backgroundView = UIView()
            backgroundView.backgroundColor = color
            self.backgroundView = backgroundView
            contentView.backgroundColor = color
        }
    }
}
