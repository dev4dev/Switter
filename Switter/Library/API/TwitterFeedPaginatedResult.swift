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

	private(set) var data: Variable<[TweetViewModel]> = Variable([])
	private(set) var loading: Bool = false
	var hasData: Bool {
		return !data.value.isEmpty
	}

	init(client: TWTRAPIClient, feedURL: String, count: Int = 20) {
		self.client = client
		self.feedURL = feedURL
		self.count = count
	}

	/// Get tweet by id
	///
	/// - Parameter index: Tweet's id
	/// - Returns: TweetViewModel object
	func tweet(at index: Int) -> TweetViewModel? {
		guard index < data.value.count else { return nil }
		return data.value[index]
	}

	/// Initial fetch request
	///
	/// - Returns: Observable with fetched tweets
	func start() -> Observable<[TweetViewModel]> {
		guard data.value.isEmpty else { return .empty() }

		return loadData().do(onNext: { [unowned self] tweets in
			self.data.value = tweets
		})
	}

	/// Fetches older tweets
	///
	/// - Returns: Observable with fetched tweets
	func loadOld() -> Observable<[TweetViewModel]> {
		guard let lastTweet = data.value.last else { return .empty() }

		return loadData(with: ["max_id": lastTweet.id]).do(onNext: { [unowned self] tweets in
			self.data.value += tweets.dropFirst()
		})
	}

	/// Fetches new tweets
	///
	/// - Returns: Observable with fetched tweets
	func loadNew() -> Observable<[TweetViewModel]> {
		guard let firstTweet = data.value.first else { return .empty() }

		return loadData(with: ["since_id": firstTweet.id]).do(onNext: { [unowned self] tweets in
			self.data.value = tweets + self.data.value
		})
	}

	private func loadData(with parameters: [AnyHashable: Any] = [:]) -> Observable<[TweetViewModel]> {
		guard !loading else { return .empty() }

		loading = true
		let defaults: [AnyHashable: Any] = ["count": "\(count)"]
		let params = parameters.merging(defaults) { (old, _) -> Any in
			return old
		}
		let request = client.urlRequest(withMethod: "GET", url: feedURL, parameters: params, error: nil)
		return client.sendRequest(request).map { data in
			let tweets = TWTRTweet.tweets(withJSONArray: data.toJSONArray()) as! [TWTRTweet]
			return tweets.map({ tweet in
				return TweetViewModel(model: tweet)
			})
		}.do(onError: { [weak self] _ in
			guard let strongSelf = self else { return }
			strongSelf.loading = false
		}, onCompleted: {  [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.loading = false
		})
	}
}
