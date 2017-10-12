//
//  UIAlertController+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit

extension UIAlertController {
	static func alert(withTitle title: String, for error: Error) -> UIAlertController {
		let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
		vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		return vc
	}

	static func info(withTitle title: String, message: String) -> UIAlertController {
		let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
		vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		return vc
	}

	func show(in controller: UIViewController) {
		controller.present(self, animated: true, completion: nil)
	}
}
