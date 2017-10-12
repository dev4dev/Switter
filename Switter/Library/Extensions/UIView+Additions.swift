//
//  UIView+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
	func addSubview(_ view: UIView, layout: (_ make: ConstraintMaker) -> Void) {
		addSubview(view)
		view.snp.makeConstraints(layout)
	}

	class func loadFromXib(inBundle bundle: Bundle = Bundle.main) -> Self {
		func helper<T>() -> T {
			return bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! T
		}

		return helper()
	}
}
