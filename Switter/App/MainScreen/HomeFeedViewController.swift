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
	private var listViewController: TweetsListViewController!

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
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Feed", style: .plain, target: nil, action: nil)
		view.backgroundColor = .white

		let menuItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showUseMenu))
		navigationItem.rightBarButtonItem = menuItem

		// list
		listViewController = TweetsListViewController(dataSource: feed.data.asObservable())
		addChildViewController(listViewController)
		view.addSubview(listViewController.view) { make in
			make.edges.equalToSuperview()
		}
		listViewController.didMove(toParentViewController: self)
		listViewController.didScrollToEnd.filter({ [unowned self] in
			return !self.feed.loading
		}).flatMapLatest { [unowned self] in
			return self.feed.loadOld()
		}.subscribe().disposed(by: trash)
		listViewController.didPullToRefresh.filter { [unowned self] in
			return !self.feed.loading
		}.flatMapLatest { [unowned self] _ -> Observable<[TweetViewModel]> in
			if self.feed.hasData {
				return self.feed.loadNew()
			} else {
				return self.feed.start()
			}
		}.subscribe().disposed(by: trash)
		listViewController.didSelectTweetAtIndex.map(feed.tweet).subscribe(onNext: { [weak self] tweet in
			guard let tweet = tweet else { return }
			self?.showDetails(for: tweet)
		}).disposed(by: trash)
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

		let loginVC = LoginViewController(client: client)
		UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
			window.rootViewController = loginVC
		}, completion: nil)
	}

	private func showDetails(for tweet: TweetViewModel) {
		let vc = DetailsViewController(viewModel: tweet, client: client)
		navigationController?.pushViewController(vc, animated: true)
	}
}

