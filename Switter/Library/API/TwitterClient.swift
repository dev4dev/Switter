//
//  TwitterClient.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import Foundation
import TwitterKit
import RxSwift
import RxCocoa
import Keys

final class TwitterClient {
	typealias LoginResult = Result<Bool, NSError>
	fileprivate let trash = DisposeBag()
	var twitter: Twitter {
		return Twitter.sharedInstance()
	}

	lazy var isLoggedIn: Variable<Bool> = Variable(twitter.sessionStore.hasLoggedInUsers())

	init(keys: SwitterKeys) {
		setup(with: keys)
		NotificationCenter.default.rx.notification(Notification.Name.TWTRUserDidLogIn).map { _ in return true }.bind(to: isLoggedIn).disposed(by: trash)
		NotificationCenter.default.rx.notification(Notification.Name.TWTRUserDidLogOut).map { _ in return true }.bind(to: isLoggedIn).disposed(by: trash)
	}

	private func setup(with keys: SwitterKeys) {
		twitter.start(withConsumerKey: keys.apiKey, consumerSecret: keys.apiSecret)
	}

	func logIn(with container: UIViewController) -> Observable<LoginResult> {
		return Observable.create({ obs in
			self.twitter.logIn(with: container) { (session, error) in
				if session != nil {
					obs.onNext(.success(true))
				} else if let error = error {
					obs.onNext(Result<Bool, NSError>.failure(error as NSError))
				}
			}
			return Disposables.create()
		})
	}

	func handleOpenUrl(application: UIApplication, url: URL, options: [AnyHashable: Any]) -> Bool {
		return twitter.application(application, open: url, options: options)
	}
}
