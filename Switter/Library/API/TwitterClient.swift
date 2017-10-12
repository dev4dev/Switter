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
	typealias LoginResult = Result<Void, NSError>
	private let trash = DisposeBag()
	private var twitter: Twitter {
		return Twitter.sharedInstance()
	}
	private lazy var apiClient: TWTRAPIClient =	TWTRAPIClient()

	private(set) lazy var isLoggedIn: Variable<Bool> = Variable(twitter.sessionStore.hasLoggedInUsers())

	init(keys: SwitterKeys) {
		setup(with: keys)
		NotificationCenter.default.rx.notification(Notification.Name.TWTRUserDidLogIn).map { _ in return true }.bind(to: isLoggedIn).disposed(by: trash)
		NotificationCenter.default.rx.notification(Notification.Name.TWTRUserDidLogOut).map { _ in return false }.bind(to: isLoggedIn).disposed(by: trash)
	}

	private func setup(with keys: SwitterKeys) {
		twitter.start(withConsumerKey: keys.apiKey, consumerSecret: keys.apiSecret)
	}

	func login(with container: UIViewController) -> Observable<LoginResult> {
		return Observable.create({ obs in
			self.twitter.logIn(with: container) { (session, error) in
				if session != nil {
					obs.onNext(.success(Void()))
				} else if let error = error {
					obs.onNext(Result<Void, NSError>.failure(error as NSError))
				}
			}
			return Disposables.create()
		})
	}

	func handleOpenUrl(application: UIApplication, url: URL, options: [AnyHashable: Any]) -> Bool {
		return twitter.application(application, open: url, options: options)
	}

	func logout() -> Observable<Void> {
		guard let session = self.twitter.sessionStore.session() else {
			return Observable.just(Void())
		}
		return Observable.create({ obs -> Disposable in
			self.twitter.sessionStore.logOutUserID(session.userID)
			obs.onCompleted()
			return Disposables.create()
		})
	}
}
