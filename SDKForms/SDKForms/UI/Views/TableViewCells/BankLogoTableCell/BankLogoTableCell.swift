//
//  BankLogoTableCell.swift
//  SDKForms
//
// 
//

import UIKit
import WebKit

final class BankLogoTableCell: UITableViewCell {
    
    private lazy var bankLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .bankLogoUnknownImage
        
        return imageView
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = ThemeSetting.shared.colorInactiveBorderTextView()
        
        return view
    }()
    
    private var model: BankLogoTableModel?
    
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
    
    func bind(model: BankLogoTableModel) -> Self {
        self.model = model
        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        imageContainerView.addSubview(bankLogoImageView)
        contentView.addSubview(imageContainerView)
    }
    
    private func setupLayout() {
        imageContainerView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                bankLogoImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 12),
                bankLogoImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 12),
                bankLogoImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -12),
                bankLogoImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -12),
                
                imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
                imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                imageContainerView.heightAnchor.constraint(equalToConstant: 44),
                imageContainerView.widthAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
}
