//
//  AppDelegate.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import Keys

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let client: TwitterClient = TwitterClient(keys: SwitterKeys())

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		let rootVC: UIViewController
		if client.isLoggedIn.value {
			rootVC = HomeFeedViewController(client: client).embedIntoNavigation()
		} else {
			rootVC = LoginViewController(client: client)
		}
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = rootVC
		window?.makeKeyAndVisible()

		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		return client.handleOpenUrl(application: app, url: url, options: options)
	}
}

