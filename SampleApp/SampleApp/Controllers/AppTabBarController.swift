//
//  AppTabBarController.swift
//  MyStore
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

        let sdkCoreImage: UIImage?
        let sdkPaymentImage: UIImage?

        if #available(iOS 13.0, *) {
            sdkCoreImage = UIImage(systemName: "sdkCore")
            sdkPaymentImage = UIImage(systemName: "sdkPayment")
        } else {
            sdkCoreImage = UIImage(named: "sdkCore")
            sdkPaymentImage = UIImage(named: "sdkPayment")
        }

        sdkCoreNavigationController.tabBarItem = UITabBarItem(
            title: "SDK Core",
            image: sdkCoreImage,
            selectedImage: nil
        )
        sdkPaymentNavigationController.tabBarItem = UITabBarItem(
            title: "SDK Payment",
            image: sdkPaymentImage,
            selectedImage: nil
        )

        self.viewControllers = [sdkCoreNavigationController, sdkPaymentNavigationController,]
    }
}
