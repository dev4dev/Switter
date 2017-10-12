//
//  LoginViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
	private let trash = DisposeBag()
	private let client: TwitterClient

	// MARK: - UI
	@IBOutlet weak var loginButton: UIButton!

	init(client: TwitterClient) {
		self.client = client
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		client.isLoggedIn.asDriver().filter { $0 == true }.drive(onNext: { [weak self] _ in
			self?.navigateToFeedScreen()
		}).disposed(by: trash)

		loginButton.rx.tap.asObservable().flatMapLatest { [unowned self] _ in
			return self.client.login(with: self)
		}.subscribe(onNext: { result in
			if case .failure(let error) = result {
				UIAlertController.alert(withTitle: "Login Error", for: error).show(in: self)
			}
		}).disposed(by: trash)
    }

	private func navigateToFeedScreen() {
		guard let window = UIApplication.shared.keyWindow else { return }

		let feedVC = HomeFeedViewController(client: client).embedIntoNavigation()
		UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
			window.rootViewController = feedVC
		}, completion: nil)
	}
}
