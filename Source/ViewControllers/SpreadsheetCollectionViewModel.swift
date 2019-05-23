//
//  SpreadsheetCollectionViewDataSource.swift
//  SpreadsheetLayout
//
//  Created by Jeff Kereakoglow on 7/6/18.
//  Copyright © 2018 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetCollectionViewModel: NSObject {}

// MARK: - UICollectionViewDataSource
extension SpreadsheetCollectionViewModel: UICollectionViewDataSource {
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
            text = ""

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

// MARK: - UICollectionViewDelegate
extension SpreadsheetCollectionViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Selected item at \(indexPath)")
    }
}

// MARK: - SpreadsheetLayoutDelegate
extension SpreadsheetCollectionViewModel: SpreadsheetLayoutDelegate {
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        return 100
    }

    func height(forRow row: Int, collectionView: UICollectionView) -> CGFloat {
        return 75
    }
}
