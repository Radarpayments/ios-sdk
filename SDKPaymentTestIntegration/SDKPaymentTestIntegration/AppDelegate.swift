//
//  AppDelegate.swift
//  SDKPaymentIntegration
//

//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var selfwindow: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        selfwindow = UIWindow(frame: UIScreen.main.bounds)
        
        selfwindow!.rootViewController = UINavigationController(rootViewController: ViewController())
        selfwindow!.makeKeyAndVisible()
        
        if ProcessInfo.processInfo.arguments.contains("-uiTesting") {
            UIView.setAnimationsEnabled(false)
        }
        
        return true
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    private var window: UIWindow? {
        selfwindow
    }
}
