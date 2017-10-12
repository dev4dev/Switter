//
//  Data+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation

extension Data {
	func toJSONDict() -> [AnyHashable: Any] {
		guard let obj = try? JSONSerialization.jsonObject(with: self, options: []) else { return [:] }
		guard let json = obj as? [AnyHashable: Any] else { return [:] }
		return json
	}

	func toJSONArray() -> [Any] {
		guard let obj = try? JSONSerialization.jsonObject(with: self, options: []) else { return [] }
		guard let json = obj as? [Any] else { return [] }
		return json
	}
}
