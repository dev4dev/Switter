//
//  UIViewController+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit

extension UIViewController {
	func embedIntoNavigation() -> UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
