//
//  ApplePayTableCell.swift
//  SDKForms
//
// 
//

import UIKit
import PassKit

protocol ApplePayTableCellDelegate: AnyObject {
    
    func clickOnApplePayButton()
}

final class ApplePayTableCell: UITableViewCell {
    
    private var applePayButton: PKPaymentButton?
    
    private var model: ApplePayTableModel?
    private weak var delegate: ApplePayTableCellDelegate?
    
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
    
    func bind(
        model: ApplePayTableModel,
        delegate: ApplePayTableCellDelegate?
    ) -> Self {
        self.model = model
        self.delegate = delegate

        let style: PKPaymentButtonStyle
        
        switch ThemeSetting.shared.getTheme() {
        case .light:
            style = .black
        case .dark:
            style = .white
        default:
            if #available(iOS 14.0, *) {
                style = .automatic
            } else {
                style = .black
            }
        }
        
        applePayButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: style)
        applePayButton?.addTarget(self, action: #selector(self.clickOnButton(_:)), for: .touchUpInside)
        
        setupSubviews()
        setupLayout()
        
        setNeedsLayout()
        applePayButton?.setNeedsLayout()

        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        if let applePayButton {
            contentView.addSubview(applePayButton)
        }
    }
    
    private func setupLayout() {
        guard let applePayButton else { return }

        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                applePayButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                applePayButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                applePayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                applePayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                applePayButton.heightAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
    
    @objc
    func clickOnButton(_ sender: PKPaymentButton) {
        delegate?.clickOnApplePayButton()
    }
}
