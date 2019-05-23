//
//  SpreadsheetViewController.swift
//  SpreadsheetLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetViewController: UICollectionViewController {
    var viewModel: SpreadsheetCollectionViewModel? {
        didSet {
            guard let layout = collectionView?.collectionViewLayout as? SpreadsheetCollectionViewLayout else {
                assertionFailure("Expected a SpreadsheetLayout")
                return
            }

            viewModel?.dataSource = self
            collectionView?.dataSource = viewModel
            collectionView?.delegate = viewModel
            layout.delegate = viewModel

            collectionView!.reloadData()
        }
    }

    private let headerCellReuseIdentifier = "HeaderCollectionViewCell"
    private let contentCellReuseIdentifier = "ContentCollectionViewCell"

    init() {
        super.init(collectionViewLayout: SpreadsheetCollectionViewLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: TextCollectionViewCell.self)

        collectionView?.register(
            UINib(nibName: headerCellReuseIdentifier, bundle: bundle),
            forCellWithReuseIdentifier: headerCellReuseIdentifier
        )

        collectionView?.register(
            UINib(nibName: contentCellReuseIdentifier, bundle: bundle),
            forCellWithReuseIdentifier: contentCellReuseIdentifier
        )
    }
}

extension SpreadsheetViewController: SpreadsheetCollectionViewModelDataSource {
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        switch (column: indexPath.row, row: indexPath.section) {
        // Origin
        case (0, 0):
            return headerCellReuseIdentifier

        // Top row
        case (_, 0):
            return headerCellReuseIdentifier

        // Left column
        case (0, _):
            return headerCellReuseIdentifier

        // Inner-content
        default:
            return contentCellReuseIdentifier
        }
    }

    func configure(_ cell: UICollectionViewCell, with content: String) {
        guard let textCollectionViewCell = cell as? TextCollectionViewCell else {
            assertionFailure("Expected a TextCollectionViewCell")
            return
        }

        textCollectionViewCell.text = content
    }
}
