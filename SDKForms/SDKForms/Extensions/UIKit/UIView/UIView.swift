//
//  UIView.swift
//  SDKForms
//
// 
//

import UIKit
import AudioToolbox

extension UIView {
    
    func animateError() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 8, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 8, y: self.center.y)
        animation.isRemovedOnCompletion = true
        self.layer.add(animation, forKey: "position")
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
