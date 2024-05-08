//
//  BottomSheetPresentable.swift
//  SDKForms
//
// 
//

import UIKit

public protocol BottomSheetPresentable: UIViewController, 
                                        UIViewControllerTransitioningDelegate {
    
    var driver: BottomSheetTransitionDriver? { get set }
    var tableContentSizeObserver: NSKeyValueObservation? { get set }
    var presentationMaxHeight: CGFloat { get }
    
    func updateHeightView(tableHeight: CGFloat)
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning?

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning?

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning?
}
