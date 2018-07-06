//
//  UICollectionView.swift
//  SpreadsheetLayout
//
//  Created by Jeff Kereakoglow on 7/6/18.
//  Copyright © 2018 brightec. All rights reserved.
//


import UIKit.UICollectionView

extension UICollectionView {
    func registerNibsWithReuseIdentifierMap(_ reuseIdentifierMap: [String: UICollectionViewCell.Type]) {
        reuseIdentifierMap.forEach { (reuseIdentifier, cellType) in
            let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: cellType))
            self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}
