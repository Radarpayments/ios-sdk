//
//  TwoTextFieldsTableCell.swift
//
//
// 
//

import UIKit

final class TwoTextFieldsTableCell: UITableViewCell {
    
    private lazy var leadingTextFieldView: CardDataTextFieldView = {
        let view = CardDataTextFieldView()
        
        return view
    }()
    
    private lazy var trailingTextFieldView: CardDataTextFieldView = {
        let view = CardDataTextFieldView()
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews:
                [
                    leadingTextFieldView,
                    trailingTextFieldView
                ]
        )
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private var model: (any TwoTextFieldsTableModelProtocol)?
    
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
    
    func bind(model: any TwoTextFieldsTableModelProtocol) -> Self {
        self.model = model
        
        set(model.leadingTextFieldViewConfig, for: leadingTextFieldView)
        set(model.trailingTextFieldViewConfig, for: trailingTextFieldView)

        return self
    }
    
    private func set(_ viewState: CardDataTextFieldViewState?, for textFieldView: CardDataTextFieldView) {
        guard let viewState else {
            textFieldView.isHidden = true
            return
        }
        
        textFieldView.setState(viewState)
        textFieldView.setTextChangingHandler { [weak self] text in
            guard let self else { return }
            
            viewState.textFieldViewTextDidChange?(textFieldView)
        }
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

extension TwoTextFieldsTableCell: InputCell {
    
    var inputViews: [InputView] {
        [ leadingTextFieldView, trailingTextFieldView ]
    }
}
