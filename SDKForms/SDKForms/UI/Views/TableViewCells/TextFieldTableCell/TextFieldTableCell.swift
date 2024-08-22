//
//  TextFieldTableCell.swift
//  SDKForms
//
// 
//

import UIKit

class TextFieldTableCell: UITableViewCell {
    
    private lazy var textFieldView = CardDataTextFieldView()
    
    private var model: (any TextFieldTableModelProtocol)?
    
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
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: Self.description())
    }
    
    func bind(model: any TextFieldTableModelProtocol) -> Self {
        self.model = model
        
        textFieldView.setState(model.textFieldViewConfig)
        textFieldView.setTextChangingHandler { [weak self] text in
            guard let self else { return }
            
            model.textFieldViewConfig.textFieldViewTextDidChange?(self.inputView())
        }
        
        return self
    }
    
    private func inputView() -> InputView {
        textFieldView
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

extension TextFieldTableCell: InputCell {
    
    var inputViews: [InputView] {
        [ textFieldView ]
    }
}
