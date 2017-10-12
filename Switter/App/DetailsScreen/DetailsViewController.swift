//
//  DetailsViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import RxSwift

final class DetailsViewController: UIViewController {
	private let trash = DisposeBag()

	private let viewModel: TweetViewModel
	private let client: TwitterClient
	private var tweetView: TweetView!

	init(viewModel: TweetViewModel, client: TwitterClient) {
		self.viewModel = viewModel
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
		navigationItem.title = viewModel.title
		view.backgroundColor = .white
		let menuItem = UIBarButtonItem(title: "°°°", style: .plain, target: self, action: #selector(showMenu))
		navigationItem.rightBarButtonItem = menuItem
		
		tweetView = TweetView.loadFromXib()
		view.addSubview(tweetView) { make in
			if #available(iOS 11.0, *) {
				make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			} else {
				make.top.equalTo(self.topLayoutGuide.snp.bottom)
			}
			make.left.right.equalToSuperview()
		}
		tweetView.viewModel = viewModel
	}

	@objc private func showMenu() {
		let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		vc.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { [unowned self] _ in
			self.client.retweet(tweetID: self.viewModel.id).subscribe({ event in
				print(event)
				switch event {
				case .completed:
					UIAlertController.info(withTitle: "Retweet", message: "Successfully!").show(in: self)
				case .error(let error):
					UIAlertController.alert(withTitle: "Request Error", for: error).show(in: self)
				default:
					break
				}
			}).disposed(by: self.trash)
		}))
		vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(vc, animated: true, completion: nil)
	}
}
