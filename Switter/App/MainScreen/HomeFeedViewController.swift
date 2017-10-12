//
//  ViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import RxSwift

final class HomeFeedViewController: UIViewController {
	private let trash = DisposeBag()
	private let client: TwitterClient
	private let feed: TwitterFeedPaginatedResult

	// MARK: - UI
	private var loginButton: UIButton?
	private var listViewController: TweetsListViewController?

	init(client: TwitterClient) {
		self.client = client
		self.feed = client.homeFeed()
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupBindings()
		setupUI()
		setupFeed()
	}

	private func setupFeed() {
		feed.start().subscribe().disposed(by: trash)
	}

	private func setupBindings() {
		client.isLoggedIn.asDriver().filter { $0 == false }.drive(onNext: { [weak self] _ in
			self?.navigateToLoginScreen()
		}).disposed(by: trash)
	}

	private func setupUI() {
		navigationItem.title = "Switter 🐦"
		view.backgroundColor = .white

		let menuItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showUseMenu))
		navigationItem.rightBarButtonItem = menuItem

		// list
		let listVC = TweetsListViewController(dataSource: feed.data.asObservable())
		addChildViewController(listVC)
		view.addSubview(listVC.view) { make in
			make.edges.equalToSuperview()
		}
		listVC.didMove(toParentViewController: self)
		listVC.didScrollToEnd.filter({ [unowned self] _ in
			return !self.feed.loading
		}).flatMapLatest { [unowned self] _ in
			return self.feed.loadOld()
		}.subscribe().disposed(by: trash)
		listVC.didSelectTweetAtIndex.map(feed.tweet).subscribe(onNext: { tweet in
			print("show details for \(tweet)")
		}).disposed(by: trash)
		listViewController = listVC
	}

	@objc private func showUseMenu() {
		let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		vc.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [unowned self] _ in
			self.client.logout().subscribe().disposed(by: self.trash)
		}))
		vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(vc, animated: true, completion: nil)
	}

	private func navigateToLoginScreen() {
		guard let window = UIApplication.shared.keyWindow else { return }

		let feedVC = LoginViewController(client: client)
		UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
			window.rootViewController = feedVC
		}, completion: nil)
	}
}

