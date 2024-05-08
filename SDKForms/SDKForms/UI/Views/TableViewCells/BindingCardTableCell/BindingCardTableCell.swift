//
//  BindingCardTableCell.swift
//  SDKForms
//
// 
//

import UIKit

final class BindingCardTableCell: UITableViewCell {
    
    private lazy var cardSystemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeSetting.shared.colorLabel()
        label.font = .sfPro15

        return label
    }()
    
    private lazy var expiryDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeSetting.shared.colorLabel()
        label.font = .sfPro15

        return label
    }()
    
    private lazy var dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeSetting.shared.colorSeparator()
        
        return view
    }()
    
    private var model: BindingCardTableModel?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupSubviews()
        setupLayout()
    }
    
    func bind(model: BindingCardTableModel) -> Self {
        self.model = model
        
        if let imageName = model.cardSystemImageName {
            cardSystemImageView.image = UIImage(resource: ImageResource(name: imageName, bundle: .sdkFormsBundle))
        }
        
        cardNumberLabel.text = model.cardNumberText
        expiryDateLabel.text = model.cardExpiryText
        accessoryType = .disclosureIndicator
        accessibilityIdentifier = model.cardNumberText
        
        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(cardSystemImageView)
        contentView.addSubview(cardNumberLabel)
        contentView.addSubview(expiryDateLabel)
        contentView.addSubview(dividerLine)
        
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                cardSystemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                cardSystemImageView.heightAnchor.constraint(equalToConstant: 24),
                cardSystemImageView.widthAnchor.constraint(equalToConstant: 36),
                cardSystemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
                cardSystemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
                
                cardNumberLabel.leadingAnchor.constraint(equalTo: cardSystemImageView.trailingAnchor, constant: 16),
                cardNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                expiryDateLabel.leadingAnchor.constraint(equalTo: cardNumberLabel.trailingAnchor, constant: 16),
                expiryDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                dividerLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                dividerLine.leadingAnchor.constraint(equalTo: cardNumberLabel.leadingAnchor),
                dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                dividerLine.heightAnchor.constraint(equalToConstant: 0.5)
            ]
        )
    }
}
