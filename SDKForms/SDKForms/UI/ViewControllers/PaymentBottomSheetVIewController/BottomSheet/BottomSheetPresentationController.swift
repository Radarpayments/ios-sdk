//
//  BottomSheetPresentationController.swift
//  SDKForms
//
// 
//

import UIKit

final class BottomSheetPresentationController: UIPresentationController {
    
    private let dimmViewBgColor = UIColor(
        red: .zero,
        green: .zero,
        blue: .zero,
        alpha: 0.24
    )
    
    override var shouldPresentInFullscreen: Bool {
        false
    }
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = dimmViewBgColor
        view.addGestureRecognizer(tapRecognizer)
        return view
    }()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        
        return recognizer
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        dimmingView.alpha = .zero
        
        performAlongsideTransitionIfPossible {
            self.dimmingView.alpha = 1
        }
        
        setupSubviews()
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            presentedView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        performAlongsideTransitionIfPossible {
            self.dimmingView.alpha = 1
        }
    }
    
    private func performAlongsideTransitionIfPossible(
        _ animation: @escaping () -> Void
    ) {
        guard let coordinator = presentedViewController.transitionCoordinator
        else {
            animation()
            return
        }

        coordinator.animate { _ in
            animation()
        }
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    private func setupSubviews() {
        guard let containerView, let presentedView else { return }
        
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedView)
        
        containerView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let presentedMaxHeight = min(
            (presentedViewController as? BottomSheetPresentable)?.presentationMaxHeight ?? .zero,
            UIScreen.main.bounds.height
        )
        
        NSLayoutConstraint.activate(
            [
                dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                
                presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                presentedView.heightAnchor.constraint(lessThanOrEqualToConstant: presentedMaxHeight)
            ]
        )
    }
}
