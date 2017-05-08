//
//  AppDelegate.swift
//  iOBJ
//
//  Created by Felipe Augusto Imianowsky on 02/05/17.
//
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
final class AppDelegate: UIResponder {
    
    var window: UIWindow?
    
    fileprivate func setupFabric() {
        Fabric.with([Crashlytics.self])
    }
    
    fileprivate func setupAppearance() {
        let foregroundColor = UIColor.orange
        let backgroundColor = UIColor.black
        let textAttributes: [String: Any] = [
            NSForegroundColorAttributeName: foregroundColor,
        ]
        window?.tintColor = foregroundColor
        do {
            let appearance = UINavigationBar.appearance()
            appearance.barTintColor = backgroundColor
            appearance.tintColor = foregroundColor
            appearance.titleTextAttributes = textAttributes
            appearance.isTranslucent = false
        }
        do {
            let appearance = UIToolbar.appearance()
            appearance.barTintColor = backgroundColor
            appearance.tintColor = foregroundColor
            appearance.isTranslucent = false
        }
        do {
            let appearance = UIBarButtonItem.appearance()
            appearance.setTitleTextAttributes(textAttributes, for:.normal)
            appearance.tintColor = foregroundColor
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupFabric()
        setupAppearance()
        return true
    }
}
