//
//  ThreeDS2WebFormDelegateImpl.swift
//  SDKPayment
//
// 
//

import UIKit

final class ThreeDS2WebFormDelegateImpl: ThreeDS2WebFormDelegate {
    
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

            let webChallengeVC = ViewController3DS2WebChallenge(
                webChallengeParam: webChallengeParam,
                viewControllerDelegate: viewControllerDelegate
            )
            
            parentController.present(webChallengeVC, animated: true)
        }
    }
}
