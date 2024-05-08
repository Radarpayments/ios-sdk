//
//  CoverVerticalPresentAnimatedTransitioning.swift
//  SDKForms
//
// 
//

import UIKit

public final class CoverVerticalPresentAnimatedTransitioning: NSObject,
                                                              UIViewControllerAnimatedTransitioning {
    
    private let presentDuration: TimeInterval = 0.2
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        presentDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = makeAnimator(using: transitionContext)
        animator?.startAnimation()
    }
    
    private func makeAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating? {
        guard let toView = transitionContext.view(forKey: .to) else { return nil }

        let containerView = transitionContext.containerView
        containerView.layoutIfNeeded()

        toView.transform = CGAffineTransform.identity
            .translatedBy(
                x: .zero,
                y: toView.frame.height
            )

        let animator = UIViewPropertyAnimator(duration: presentDuration, curve: .easeOut) {
            toView.transform = .identity
        }

        animator.addCompletion { _ in
            transitionContext
                .completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}
