//
//  BottomSheetTransitionDelegate.swift
//  SDKForms
//
// 
//

import UIKit

public final class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var driver: BottomSheetTransitionDriver?
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        guard let bottomSheetPresentable = presented as? BottomSheetPresentable else { return nil }
        
        let driver = BottomSheetTransitionDriver(controller: bottomSheetPresentable)
        self.driver = driver
        bottomSheetPresentable.transitioningDelegate = bottomSheetPresentable
        bottomSheetPresentable.driver = driver
        
        return BottomSheetPresentationController(
            presentedViewController: bottomSheetPresentable,
            presenting: presenting ?? source
        )
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        CoverVerticalPresentAnimatedTransitioning()
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        CoverVerticalDismissAnimatedTransitioning()
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        self.driver
    }
}
