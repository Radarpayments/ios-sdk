//
//  CoverVerticalDismissAnimatedTransitioning.swift
//  SDKForms
//
// 
//

import UIKit

public final class CoverVerticalDismissAnimatedTransitioning: NSObject, 
                                                                UIViewControllerAnimatedTransitioning {
    
    private let dismissDuration: TimeInterval = 0.2
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        dismissDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = makeAnimator(using: transitionContext)
        animator?.startAnimation()
    }
    
    public  func interruptibleAnimator(
         using transitionContext: UIViewControllerContextTransitioning
     ) -> UIViewImplicitlyAnimating {
         makeAnimator(using: transitionContext) ?? UIViewPropertyAnimator()
     }
    
    private func makeAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating? {
        guard let fromView = transitionContext.view(forKey: .from) else { return nil }
        
        let animator = UIViewPropertyAnimator(duration: dismissDuration, curve: .linear) {
            fromView.transform = CGAffineTransform.identity
                .translatedBy(x: .zero, y: fromView.frame.height)
        }

        animator.addCompletion { _ in
            transitionContext
                .completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}
