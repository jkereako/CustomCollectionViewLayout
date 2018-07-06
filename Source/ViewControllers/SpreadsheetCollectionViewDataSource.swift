//
//  SpreadsheetCollectionViewDataSource.swift
//  SpreadsheetLayout
//
//  Created by Jeff Kereakoglow on 7/6/18.
//  Copyright © 2018 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetCollectionViewDataSource: NSObject {}

// MARK: - UICollectionViewDataSource
extension SpreadsheetCollectionViewDataSource: UICollectionViewDataSource {
    // i.e. rows
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    // i.e. number of columns
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var identifier: SpreadsheetCollectionViewCellReuseIdentifier
        var text: String

        switch (column: indexPath.row, row: indexPath.section) {
        // Origin
        case (0, 0):
            identifier = .header
            text = "ROW \(indexPath.section)"

        // Top row
        case (_, 0):
            identifier = .header
            text = "COL \(indexPath.row)"

        // Left column
        case (0, _):
            identifier = .header
            text = "ROW \(indexPath.section)"

        // Inner-content
        default:
            identifier = .content
            text = String(arc4random_uniform(100))
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier.rawValue, for: indexPath
            ) as? TextCollectionViewCell else {
                assertionFailure("Expected a TextCollectionViewCell")
                return UICollectionViewCell()
        }

        cell.text = text

        return cell
    }
}
