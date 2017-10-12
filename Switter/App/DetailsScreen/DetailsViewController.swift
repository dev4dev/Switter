//
//  DetailsViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {

	private let viewModel: TweetViewModel
	private var tweetView: TweetView!

	init(viewModel: TweetViewModel) {
		self.viewModel = viewModel
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
}
