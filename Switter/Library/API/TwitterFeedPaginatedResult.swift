//
//  TwitterPaginatedResult.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation
import TwitterKit
import RxSwift

final class TwitterFeedPaginatedResult {
	private let trash = DisposeBag()
	private let client: TWTRAPIClient
	private let feedURL: String
	private let count: Int

	private var data: [TWTRTweet] = []

	init(client: TWTRAPIClient, feedURL: String, count: Int = 20) {
		self.client = client
		self.feedURL = feedURL
		self.count = count
	}

	func start() -> Observable<[TWTRTweet]> {
		guard data.isEmpty else { return .empty() }

		return loadData().do(onNext: { [unowned self] tweets in
			self.data = tweets
		})
	}

	func loadOld() -> Observable<[TWTRTweet]> {
		guard let lastTweet = data.last else { return .empty() }

		return loadData(with: ["max_id": lastTweet.tweetID]).do(onNext: { [unowned self] tweets in
			self.data += tweets
		})
	}

	func loadNew() -> Observable<[TWTRTweet]> {
		guard let firstTweet = data.first else { return .empty() }

		return loadData(with: ["since_id": firstTweet.tweetID]).do(onNext: { [unowned self] tweets in
			self.data = tweets + self.data
		})
}

	private func loadData(with parameters: [AnyHashable: Any] = [:]) -> Observable<[TWTRTweet]> {
		let defaults: [AnyHashable: Any] = ["count": "\(count)"]
		let params = parameters.merging(defaults) { (old, _) -> Any in
			return old
		}
		let request = client.urlRequest(withMethod: "GET", url: feedURL, parameters: params, error: nil)
		return client.sendRequest(request).map { data in
			return TWTRTweet.tweets(withJSONArray: data.toJSONArray()) as! [TWTRTweet]
		}
	}
}
