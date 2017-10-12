//
//  TweetViewModel.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation
import TwitterKit
import RxSwift

final class TweetViewModel {
	private let model: TWTRTweet

	init(model: TWTRTweet) {
		self.model = model
	}

	private var sourceModel: TWTRTweet {
		if let retweet = model.retweeted {
			return retweet
		} else {
			return model
		}
	}

	var id: String {
		return model.tweetID
	}

	var title: String {
		return "\(model.author.name)'s tweet"
	}

	var authorName: String {
		if model.retweeted != nil {
			return model.author.name + " 🔁 " + sourceModel.author.name
		} else {
			return model.author.name
		}
	}

	var content: String {
		return model.text
	}

	var authorAvatarURL: URL? {
		return URL(string: sourceModel.author.profileImageMiniURL)
	}

	var likesCount: String {
		return "\(model.likeCount) Likes"
	}

	var retweetsCount: String {
		return "\(model.retweetCount) Retweets"
	}
}
