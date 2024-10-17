//
//  TwoTextFieldsTableCell.swift
//
//
// 
//

import UIKit

protocol TwoTextFieldsTableCellDelegate: AnyObject {
    
    func cardExpiryTextDidChange(_ text: String)
    func cardCVCTextDidChange(_ text: String)
}

final class TwoTextFieldsTableCell: UITableViewCell {
    
    private lazy var cardExpiryTextFiedlView: CardDataTextFieldView = {
        let view = CardDataTextFieldView()
        
        return view
    }()
    
    private lazy var cardCVCTextFieldView: CardDataTextFieldView = {
        let view = CardDataTextFieldView()
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews:
                [
                    cardExpiryTextFiedlView,
                    cardCVCTextFieldView
                ]
        )
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private var model: TwoTextFieldsTableModel?
    private weak var delegate: TwoTextFieldsTableCellDelegate?
    
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
        model: TwoTextFieldsTableModel,
        delegate: TwoTextFieldsTableCellDelegate?
    ) -> Self {
        self.model = model
        self.delegate = delegate

        cardExpiryTextFiedlView.setState(model.cardExpiryViewConfig)
        cardCVCTextFieldView.setState(model.cardCVCViewConfig)
        
        cardExpiryTextFiedlView.setTextChangingHandler { [weak self] text in
            self?.delegate?.cardExpiryTextDidChange(text)
        }
        
        cardCVCTextFieldView.setTextChangingHandler { [weak self] text in
            self?.delegate?.cardCVCTextDidChange(text)
        }

        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()
        
        contentView.addSubview(stackView)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}
