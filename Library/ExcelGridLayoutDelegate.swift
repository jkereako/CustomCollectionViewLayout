//
//  ExcelGridLayoutDelegate.swift
//  ExcelGridLayout
//
//  Created by Jeff Kereakoglow on 7/26/16.
//  Copyright © 2016 brightec. All rights reserved.
//

import Foundation

import UIKit

protocol ExcelGridLayoutDelegate: UICollectionViewDelegate {
  func width(forColumn column: UInt, collectionView: UICollectionView) -> CGFloat
  func height(forRow row: UInt, collectionView: UICollectionView) -> CGFloat
}
