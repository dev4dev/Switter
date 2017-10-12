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
	fileprivate let trash = DisposeBag()
	let client: TwitterClient

	// MARK: - UI
	private var loginButton: UIButton?

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
	}

	private func showLoginButton() {
		let button = UIButton(type: .custom)
		button.setTitle("LogIn", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		view.addSubview(button) { make in
			make.center.equalToSuperview()
		}

		button.rx.tap.asObservable().flatMapLatest { [unowned self] _ in
			return self.client.logIn(with: self)
		}.subscribe(onNext: { result in
			if case .failure(let error) = result {
				UIAlertController.alert(withTitle: "Login Error", for: error).show(in: self)
			}
		}).disposed(by: trash)
		loginButton = button
	}
}

