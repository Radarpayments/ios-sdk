//
//  ThreeDS2WebFormDelegate.swift
//  SDKPayment
//
// 
//

import Foundation

/// Interface describing the work of the 3DS2 form.
public protocol ThreeDS2WebFormDelegate {
    
    /// Start Web Challenge screen.
    ///
    /// - Parameters:
    ///     - webChallengeParam parameters for Web Challenge.
   func openWebChallenge(webChallengeParam: WebChallengeParam)
}
