//
//  Result.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation

enum Result<T, E> where E: Error {
	case success(T)
	case failure(E)
}
