//
//  AppDelegate.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		TwitterClient.shared.setup()

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = RootViewController()
		window?.makeKeyAndVisible()

		return true
	}
}

