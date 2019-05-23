//
//  SpreadsheetCollectionViewDataSource.swift
//  SpreadsheetLayout
//
//  Created by Jeff Kereakoglow on 7/6/18.
//  Copyright © 2018 brightec. All rights reserved.
//

import UIKit

protocol SpreadsheetCollectionViewModelDataSource: class {
    func cellReuseIdentifier(for indexPath: IndexPath) -> String
    func configure(_ cell: UICollectionViewCell, with content: String)
}

final class SpreadsheetCollectionViewModel: NSObject {
    weak var dataSource: SpreadsheetCollectionViewModelDataSource?

    private var theDataSource: [[String]]

    override init() {
        theDataSource = [[String]]()

        for i in 0..<5 {
            var content = [String]()

            content.append("Col \(i)")

            for i in 0..<10 {
                var row = "\(i)"

                if i == 0 {
                    row = "Row \(i)"

                }

                content.append(row)
            }

            theDataSource.append(content)
        }

        super.init()
    }
}

// MARK: - UICollectionViewDataSource
extension SpreadsheetCollectionViewModel: UICollectionViewDataSource {
    // i.e. rows
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return theDataSource.count > 0 ? theDataSource[0].count : 0
    }

    // i.e. number of columns
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = dataSource?.cellReuseIdentifier(for: indexPath) ?? ""
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier, for: indexPath
        )

        dataSource?.configure(cell, with: "TEST")

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
extension SpreadsheetCollectionViewModel: SpreadsheetCollectionViewLayoutDelegate {
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        return 100
    }

    func height(forRow row: Int, collectionView: UICollectionView) -> CGFloat {
        return 75
    }
}
