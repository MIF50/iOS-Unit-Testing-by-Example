//
//  TestingAppDelegate.swift
//  AppLaunchTests
//
//  Created by Mohamed Ibrahim on 10/02/2023.
//

import UIKit

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(">> Launching with testing app delegate")
        return true
    }
}
