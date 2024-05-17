//
//  ThreeDS2SDKFormDelegateImpl.swift
//  SDKPayment
//
// 
//

import Foundation
import UIKit
import SDKForms
import ThreeDSSDK

final class ThreeDS2SDKFormDelegateImpl: ThreeDS2SDKFormDelegate {
    
    private var parentController: UINavigationController
    private weak var viewControllerDelegate: ViewControllerDelegate?
    
    init(
        parentController: UINavigationController,
        viewControllerDelegate: ViewControllerDelegate?
    ) {
        self.parentController = parentController
        self.viewControllerDelegate = viewControllerDelegate
    }

    func initThreeDS2Service(threeDS2Service: ThreeDS2Service) throws {
        // TODO: - Build config and UICustomization
        let configParams = ConfigParameters()
        let uiCustomization = UiCustomization()
        
        try? threeDS2Service.initialize(
            configParameters: configParams,
            locale: Locale.current.languageCode,
            uiCustomization: uiCustomization
        )
    }
    
    func openChallengeFlow(
        transaction: Transaction?,
        challengeParameters: ChallengeParameters,
        challengeStatusReceiver: ChallengeStatusReceiver
    ) throws {
        DispatchQueue.main.async {
            try? transaction?.doChallenge(
                challengeParameters: challengeParameters,
                challengeStatusReceiver: challengeStatusReceiver,
                timeOut: Constants.TIMEOUT_THREE_DS
            )
        }
    }
    
    func cleanup(
        transaction: Transaction?,
        threeDS2Service: ThreeDS2Service
    ) throws {
        do {
            try transaction?.close()
            try threeDS2Service.cleanup()
        } catch {
            throw error
        }
    }
}
