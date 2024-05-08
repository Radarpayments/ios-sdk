//
//  FormsPaymentView.swift
//  SDKForms
//
// 
//

import UIKit
import PassKit

public final class FormsPaymentView: UIView {
    
    private lazy var applePayButton: PKPaymentButton = {
        let buttonStyle: PKPaymentButtonStyle = switch ThemeSetting.shared.getTheme() {
        case .light: .black
        case .dark: .white
        default: .black
        }

        let button = PKPaymentButton(
            paymentButtonType: .buy,
            paymentButtonStyle: buttonStyle
        )
        button.cornerRadius = 8
        
        return button
    }()
    
    private lazy var newCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle(.newCard(), for: .normal)
        button.layer.cornerRadius = 8

        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                newCardButton,
                applePayButton
            ]
        )
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually

        return stack
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        addSubview(stack)
    }
    
    private func setupLayout() {
        let request = PKPaymentRequest()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stack.topAnchor.constraint(equalTo: topAnchor),
                stack.leadingAnchor.constraint(equalTo: leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                stack.heightAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
}
