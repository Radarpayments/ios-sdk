//
//  ThreeDSFormDelegate.swift
//  SDKPayment
//
// 
//

import Foundation
import ThreeDSSDK

/// Interface describing the work of the 3DS2 form.
public protocol ThreeDS2SDKFormDelegate {
    
    /// Service initialization .
    ///
    /// - Parameters:
    ///     - threeDS2Service service object.
    ///     - factory class for managing UI component.
   func initThreeDS2Service(threeDS2Service: ThreeDS2Service) throws
    
    /// Start Challenge Flow screen.
    ///
    /// - Parameters:
    ///     - transaction transaction object.
    ///     - challengeParameters parameters for Challenge Flow.
    ///     - challengeStatusReceiver callback for Challenge Flow process.
   func openChallengeFlow(
       transaction: Transaction?,
       challengeParameters: ChallengeParameters,
       challengeStatusReceiver: ChallengeStatusReceiver
   ) throws
    
    /// Stop transaction and delete data.
    ///
    /// - Parameters:
    ///     - transaction transaction object.
    ///     - threeDS2Service service object.
   func cleanup(
       transaction: Transaction?,
       threeDS2Service: ThreeDS2Service
   ) throws
}
