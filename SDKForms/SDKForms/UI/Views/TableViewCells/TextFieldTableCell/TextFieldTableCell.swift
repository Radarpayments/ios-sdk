//
//  TextFieldTableCell.swift
//  SDKForms
//
// 
//

import UIKit

protocol TextFieldTableCellDelegate: AnyObject {
    
    func textDidChange(id: String, _ text: String)
}

class TextFieldTableCell: UITableViewCell {
    
    private lazy var textFieldView = CardDataTextFieldView()
    
    private var model: (any TextFieldTableModelProtocol)?
    private weak var delegate: TextFieldTableCellDelegate?
    
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
        model: any TextFieldTableModelProtocol,
        delegate: TextFieldTableCellDelegate?
    ) -> Self {
        self.model = model
        self.delegate = delegate
        
        textFieldView.setState(model.textFieldViewConfig)
        textFieldView.setTextChangingHandler { [weak self] text in
            self?.delegate?.textDidChange(id: model.id, text)
        }
        
        return self
    }
    
    private func setupSubviews() {
        backgroundColor = ThemeSetting.shared.colorCellBackground()
        contentView.backgroundColor = ThemeSetting.shared.colorCellBackground()

        contentView.addSubview(textFieldView)
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                textFieldView.topAnchor.constraint(equalTo: contentView.topAnchor),
                textFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                textFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                textFieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}
