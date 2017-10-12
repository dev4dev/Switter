//
//  TWTRAPIClient+Additions.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation
import TwitterKit
import RxSwift

extension TWTRAPIClient {
	func sendRequest(_ request: URLRequest) -> Observable<Data> {
		return Observable.create({ obs -> Disposable in
			let progress = self.sendTwitterRequest(request) { (_, data, error) in
				if let data = data {
					obs.onNext(data)
				} else if let error = error {
					obs.onError(error)
				}
			}

			return Disposables.create {
				progress.cancel()
			}
		})
	}
}
