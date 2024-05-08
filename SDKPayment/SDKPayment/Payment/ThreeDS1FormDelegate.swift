//
//  ThreeDS1FormDelegate.swift
//  SDKPayment
//
// 
//

import Foundation

/// Interface describing the work of the 3DS1 form.
public protocol ThreeDS1FormDelegate {
    
    /// Start Web Challenge screen.
    ///
    /// - Parameters:
    ///     - webChallengeParam parameters for Web Challenge.
   func openWebChallenge(webChallengeParam: WebChallengeParam)
}
