//
//  ViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import RxSwift

final class RootViewController: UIViewController {
	private let trash = DisposeBag()
	private let client: TwitterClient
	private var feed: TwitterFeedPaginatedResult?

	// MARK: - UI
	private var loginButton: UIButton?
	private var listViewController: TweetsListViewController?

	init(client: TwitterClient) {
		self.client = client
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
	}

	private func setupUI() {
		navigationItem.title = "Switter 🐦"
		view.backgroundColor = .white

		client.isLoggedIn.asDriver().drive(onNext: { [unowned self] isLoggedIn in
			if isLoggedIn {
				self.showFeed()
			} else {
				self.showLoginButton()
			}
		}).disposed(by: trash)
	}

	private func showFeed() {
		loginButton?.removeFromSuperview()

		let menuItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showUseMenu))
		navigationItem.rightBarButtonItem = menuItem

		let homeFeed = client.fetchFeed()
		homeFeed.start().subscribe().disposed(by: trash)
		feed = homeFeed

		// list
		let listVC = TweetsListViewController(dataSource: homeFeed.data.asObservable())
		addChildViewController(listVC)
		view.addSubview(listVC.view) { make in
			make.edges.equalToSuperview()
		}
		listVC.didMove(toParentViewController: self)
		listVC.didScrollToEnd.filter({ _ in
			return !homeFeed.loading
		}).flatMapLatest { _ in
			return homeFeed.loadOld()
		}.subscribe().disposed(by: trash)
		listVC.didSelectTweetAtIndex.map(homeFeed.tweet).subscribe(onNext: { tweet in
			print("show details for \(tweet)")
		}).disposed(by: trash)
		listViewController = listVC
	}

	private func showLoginButton() {
		navigationItem.rightBarButtonItem = nil
		listViewController?.willMove(toParentViewController: nil)
		listViewController?.view.removeFromSuperview()
		listViewController?.removeFromParentViewController()

		let button = UIButton(type: .custom)
		button.setTitle("LogIn", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		view.addSubview(button) { make in
			make.center.equalToSuperview()
		}

		button.rx.tap.asObservable().flatMapLatest { [unowned self] _ in
			return self.client.login(with: self)
		}.subscribe(onNext: { result in
			if case .failure(let error) = result {
				UIAlertController.alert(withTitle: "Login Error", for: error).show(in: self)
			}
		}).disposed(by: trash)
		loginButton = button
	}

	@objc private func showUseMenu() {
		let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		vc.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [unowned self] _ in
			self.client.logout().subscribe().disposed(by: self.trash)
		}))
		vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(vc, animated: true, completion: nil)
	}
}

