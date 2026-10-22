//
//  PaymentPreloaderView.swift
//  SDKPayment
//
//

import UIKit

/// Full-screen overlay with activity indicator shown during payment processing.
final class PaymentPreloaderView: UIView {

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let style: UIActivityIndicatorView.Style = {
            if #available(iOS 13.0, *) {
                return .large
            } else {
                return .whiteLarge
            }
        }()
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(overlayView)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func show(on window: UIWindow?) {
        guard let window else { return }
        guard superview == nil else { return }

        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: window.topAnchor),
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor),
            bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func hide() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}
