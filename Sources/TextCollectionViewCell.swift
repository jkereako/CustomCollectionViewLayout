//
//  TextCollectionViewCell.swift
//  SpreadsheetLayout
//
//  Created by Jeff Kereakoglow on 7/6/18.
//  Copyright © 2018 brightec. All rights reserved.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
    var text: String? {
        didSet {
            title.text = text!
        }
    }

    @IBOutlet private weak var title: UILabel!
}
