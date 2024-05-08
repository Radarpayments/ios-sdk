//
//  ThreeDS1FormDelegateImpl.swift
//  SDKPayment
//
// 
//

import UIKit

final class ThreeDS1FormDelegateImpl: ThreeDS1FormDelegate {
    
    private var parentController: UINavigationController
    private weak var viewControllerDelegate: ViewControllerDelegate?
    
    init(
        parentController: UINavigationController,
        viewControllerDelegate: ViewControllerDelegate?
    ) {
        self.parentController = parentController
        self.viewControllerDelegate = viewControllerDelegate
    }

    func openWebChallenge(webChallengeParam: WebChallengeParam) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let webChallengeVC = ViewController3DS1Challenge(
                webChallengeParam: webChallengeParam,
                viewControllerDelegate: viewControllerDelegate
            )
            
            parentController.present(webChallengeVC, animated: true)
        }
    }
}
