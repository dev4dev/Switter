//
//  TweetsListViewController.swift
//  Switter
//
//  Created by Alex Antonyuk on 10/12/17.
//  Copyright © 2017 Alex Antonyuk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TweetsListViewController: UIViewController {
	private let trash = DisposeBag()
	private let dataSource: Observable<[TweetViewModel]>
	let didScrollToEnd = PublishSubject<Void>()
	let didSelectTweetAtIndex = PublishSubject<Int>()

	init(dataSource: Observable<[TweetViewModel]>) {
		self.dataSource = dataSource
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		setupBindings()
    }

	private func setupUI() {
		tableView = UITableView()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44.0
		tableView.tableFooterView = UIView()
		tableView.showsVerticalScrollIndicator = false
		tableView.rx.setDelegate(self).disposed(by: trash)
		tableView.rx.itemSelected.asObservable().map { indexPath in
			return indexPath.row
		}.bind(to: didSelectTweetAtIndex.asObserver()).disposed(by: trash)
		tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.identifier)
		view.addSubview(tableView) { make in
			make.edges.equalToSuperview()
		}
	}

	private func setupBindings() {
		dataSource.bind(to: tableView.rx.items(cellIdentifier: TweetCell.identifier, cellType: TweetCell.self) ) { row, element, cell in
			cell.viewModel = element
		}.disposed(by: trash)
	}
}

extension TweetsListViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.pointsToBottom() <= 40 {
			didScrollToEnd.onNext(Void())
		}
	}
}


