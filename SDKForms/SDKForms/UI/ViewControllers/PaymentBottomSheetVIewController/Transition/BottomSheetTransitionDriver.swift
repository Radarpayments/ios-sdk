//
//  BottomSheetTransitionDriver.swift
//  SDKForms
//
// 
//

import UIKit

public final class BottomSheetTransitionDriver: UIPercentDrivenInteractiveTransition, 
                                                UIGestureRecognizerDelegate {
    
    override public var wantsInteractiveStart: Bool {
        get { self.panRecognizer.state == .began }
        set { super.wantsInteractiveStart = newValue }
    }
    
    private var maxTranslation: CGFloat? {
        let height = self.presentedController?.view?.frame.height ?? .zero
        
        return height > .zero ? height : nil
    }
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleDismiss)
        )
        panRecognizer.delegate = self
        
        return panRecognizer
    }()
    
    private weak var presentedController: UIViewController?
    
    init(controller: BottomSheetPresentable) {
        super.init()
        controller.view?.addGestureRecognizer(panRecognizer)
        self.presentedController = controller
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let presentedController else { return false }
        
        let velocity = panRecognizer.velocity(in: presentedController.view)
        
        if velocity.y > .zero, abs(velocity.y) > abs(velocity.x) {
            return true
        }
        
        return false
    }
    
    @objc
    private func handleDismiss(_ sender: UIPanGestureRecognizer) {
        guard let maxTranslation else { return }
        
        switch sender.state {
        case .began:
            let isRunning = percentComplete != .zero
            if !isRunning {
                presentedController?.dismiss(animated: true)
            }

            pause()

        case .changed:
            let increment = sender.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)

        case .ended, .cancelled:
            if sender.isProjectedToDownHalf(
                maxTranslation: maxTranslation,
                percentComplete: self.percentComplete
            ) {
                finish()
                return
            }
            
            cancel()

        case .failed:
            cancel()

        default:
            break
        }
    }
}

private extension UIPanGestureRecognizer {
    
    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = translation(in: view).y
        setTranslation(.zero, in: nil)
        let percentIncrement = translation / maxTranslation
        
        return percentIncrement
    }
    
    func isProjectedToDownHalf(
        maxTranslation: CGFloat,
        percentComplete: CGFloat
    ) -> Bool {
        let velocityOffset = velocity(in: view)
            .projectedOffset(decelerationRate: .normal)
        
        let point = CGPoint(x: .zero, y: maxTranslation * percentComplete)
        let translation = point + velocityOffset
        let isPresentationCompleted = translation.y > maxTranslation / 2
        
        return isPresentationCompleted
    }
}


private extension CGPoint {
    
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        .init(
            x: x.projectedOffset(decelerationRate: decelerationRate),
            y: x.projectedOffset(decelerationRate: decelerationRate)
        )
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

private extension CGFloat {
    
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        let multiplier = 1 / (1 - decelerationRate.rawValue) / 1000
        return self * multiplier
    }
}
