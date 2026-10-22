//
//  AppTabBarController.swift
//  SampleApp
//

import UIKit

final class AppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }

    func setupTabs() {
        let sdkCoreViewController = SdkCoreViewController()
        let sdkPaymentViewController = SdkPaymentViewController()

        let sdkCoreNavigationController = UINavigationController(rootViewController: sdkCoreViewController)
        let sdkPaymentNavigationController = UINavigationController(rootViewController: sdkPaymentViewController)

        sdkCoreNavigationController.tabBarItem = UITabBarItem(
            title: "SDK Core",
            image: UIImage(systemName: "lock.shield"),
            selectedImage: UIImage(systemName: "lock.shield.fill")
        )
        sdkPaymentNavigationController.tabBarItem = UITabBarItem(
            title: "SDK Payment",
            image: UIImage(systemName: "creditcard"),
            selectedImage: UIImage(systemName: "creditcard.fill")
        )

        self.viewControllers = [sdkCoreNavigationController, sdkPaymentNavigationController,]
    }
}
