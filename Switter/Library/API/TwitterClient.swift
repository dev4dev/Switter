//
//  TwitterClient.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation
import TwitterKit
import Keys

final class TwitterClient {
	static let shared = TwitterClient()
	var twitter: Twitter {
		return Twitter.sharedInstance()
	}

	var isAuthorized: Bool {
		return twitter.sessionStore.hasLoggedInUsers()
	}

	private init() {
		
	}

	func setup() {
		let keys = SwitterKeys()
		twitter.start(withConsumerKey: keys.apiKey, consumerSecret: keys.apiKey)
	}
}
