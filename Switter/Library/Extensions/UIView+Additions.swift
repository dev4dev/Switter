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
}
