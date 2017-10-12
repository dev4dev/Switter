//
//  TweetView.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import Kingfisher

final class TweetView: UIView {
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var retweetsLabel: UILabel!

	var viewModel: TweetViewModel? {
		didSet {
			updateUI()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		avatarImageView.kf.indicatorType = .activity
	}

	func clearView() {
		nameLabel.text = nil
		contentLabel.text = nil
		avatarImageView.image = nil
		retweetsLabel.text = nil
		likesLabel.text = nil
	}

	private func updateUI() {
		guard let viewModel = viewModel else { return }

		nameLabel.text = viewModel.authorName
		contentLabel.text = viewModel.content
		avatarImageView.kf.setImage(with: viewModel.authorAvatarURL)
		retweetsLabel.text = viewModel.retweetsCount
		likesLabel.text = viewModel.likesCount
	}
}
