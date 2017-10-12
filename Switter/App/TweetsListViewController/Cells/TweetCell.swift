//
//  TweetCell.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import SnapKit

final class TweetCell: UITableViewCell {
	static var identifier: String = "TweetCell"

	private var tweetView: TweetView!

	var viewModel: TweetViewModel? {
		didSet {
			tweetView?.viewModel = viewModel
		}
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		tweetView = TweetView.loadFromXib()

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(tweetView) { make in
			make.edges.equalToSuperview()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

		tweetView?.clearView()
	}
}
