//
//  VerifyCompaniesReusableView.swift
//  SDKForms
//
// 
//

import UIKit

final class VerifyCompaniesReusableView: UIView {
    
    private lazy var visaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .visaVerifyImage
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var jcbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .jcbVerifyImage
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var pciImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pciVerifyImage
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var masterCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .verifyMastercardImage
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                visaImageView,
                jcbImageView,
                pciImageView,
                masterCardImageView
            ]
        )
        stack.axis = .horizontal
        stack.spacing = 16
        
        return stack
    }()
    
    override init(frame: CGRect) {
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
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        stack.arrangedSubviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                heightAnchor.constraint(equalToConstant: 44),
                stack.topAnchor.constraint(equalTo: topAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor),
                stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
            ]
        )
        
        stack.arrangedSubviews.forEach {
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
}
