//
//  AddNewCardTableCell.swift
//  SDKForms
//
// 
//

import UIKit

final class AddNewCardTableCell: UITableViewCell {
    
    private lazy var addCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var addCardTitleLabel: UILabel = {
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
    
    private var model: AddNewCardTableModel?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
    }
    
    func bind(model: AddNewCardTableModel) -> Self {
        self.model = model
        
        if let leftImageName = model.leftImageName {
            addCardImageView.image = UIImage(resource: ImageResource(name: leftImageName, bundle: .sdkFormsBundle))
        }
        addCardTitleLabel.text = model.title
        accessoryType = .disclosureIndicator
        
        accessibilityIdentifier = model.title

        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(addCardImageView)
        contentView.addSubview(addCardTitleLabel)
        contentView.addSubview(dividerLine)
        
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                addCardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                addCardImageView.heightAnchor.constraint(equalToConstant: 24),
                addCardImageView.widthAnchor.constraint(equalToConstant: 36),
                addCardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
                addCardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
                
                addCardTitleLabel.leadingAnchor.constraint(equalTo: addCardImageView.trailingAnchor, constant: 16),
                addCardTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
        )
    }
}
