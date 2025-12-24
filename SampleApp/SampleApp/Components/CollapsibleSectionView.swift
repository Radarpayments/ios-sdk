//
//  CollapsibleSectionView.swift
//  MyStore
//

import UIKit

class CollapsibleSectionView: UIView {
    private let headerButton = UIButton(type: .system)
    private let chevronImageView = UIImageView()
    private let contentView: UIView
    private var isCollapsed: Bool
    private var contentHeightConstraint: NSLayoutConstraint!

    init(title: String, contentView: UIView, isCollapsed: Bool = true) {
        self.contentView = contentView
        self.isCollapsed = isCollapsed
        super.init(frame: .zero)

        headerButton.setTitle(title, for: .normal)
        headerButton.setTitleColor(.adaptiveLabel, for: .normal)
        headerButton.contentHorizontalAlignment = .left
        headerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        headerButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)

        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = .adaptiveLabel

        addSubview(headerButton)
        addSubview(contentView)
        headerButton.addSubview(chevronImageView)

        headerButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: topAnchor),
            headerButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerButton.heightAnchor.constraint(equalToConstant: 44),

            chevronImageView.centerYAnchor.constraint(equalTo: headerButton.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: headerButton.trailingAnchor, constant: -12),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),

            contentView.topAnchor.constraint(equalTo: headerButton.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Ensure the title doesn't overlap the chevron without using deprecated contentEdgeInsets
        if let titleLabel = headerButton.titleLabel {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerButton.leadingAnchor, constant: 0),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),
                titleLabel.centerYAnchor.constraint(equalTo: headerButton.centerYAnchor)
            ])
        }

        updateCollapsedState()
        updateHeaderButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggle() {
        isCollapsed.toggle()
        updateCollapsedState()
        updateHeaderButton()
    }

    private func updateCollapsedState() {
        if isCollapsed {
            contentHeightConstraint.isActive = true
            contentView.isHidden = true
        } else {
            contentHeightConstraint.isActive = false
            contentView.isHidden = false
        }
    }

    private func updateHeaderButton() {
        var image: UIImage?

        if #available(iOS 13.0, *) {
            let symbol = isCollapsed ? "chevron.right" : "chevron.down"
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)

            image = UIImage(systemName: symbol, withConfiguration: config)
        } else {
            let arrow = isCollapsed ? "▶" : "▼"
            let font = UIFont.systemFont(ofSize: 12)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.adaptiveLabel
            ]
            let attributedString = NSAttributedString(string: arrow, attributes: attributes)
            let size = attributedString.size()

            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            attributedString.draw(at: .zero)

            image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
        }

        chevronImageView.image = image
    }
}
