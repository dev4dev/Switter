//
//  UIScrollView+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit

extension UIScrollView {
	func pointsToBottom() -> CGFloat {
		return contentSize.height - contentOffset.y - bounds.height
	}
}
