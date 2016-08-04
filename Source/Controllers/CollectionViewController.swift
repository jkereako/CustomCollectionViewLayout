//
//  CollectionViewController.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  private var columnHeaderSizingCell: UICollectionViewCell!
  private var rowContentSizingCell: UICollectionViewCell!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rowContentNib = UINib(nibName: "RowContentCell", bundle: nil)
    let columnHeaderNib = UINib(nibName: "ColumnHeaderCell", bundle: nil)
    
    collectionView.registerNib(rowContentNib, forCellWithReuseIdentifier: "rowContent")
    collectionView.registerNib(columnHeaderNib, forCellWithReuseIdentifier: "columnHeader")
    
    rowContentSizingCell = rowContentNib.instantiateWithOwner(nil, options: nil).first as! UICollectionViewCell
    columnHeaderSizingCell = columnHeaderNib.instantiateWithOwner(nil, options: nil).first  as! UICollectionViewCell
    
    let layout = collectionView.collectionViewLayout as! SpreadsheetLayout
    layout.delegate = self
  }
  
  // MARK - UICollectionViewDataSource
  // i.e. number of rows
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 10
  }
  
  // i.e. number of columns
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    
    switch (column: indexPath.row, row: indexPath.section) {
    case (0, 0):
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "columnHeader", forIndexPath: indexPath
        ) as! ColumnHeaderCell
      
      cell.backgroundColor = UIColor.grayColor()
      cell.title.text = "ROW \(indexPath.section)"
      
      return cell
      
    case (_, 0):
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "columnHeader", forIndexPath: indexPath
        ) as! ColumnHeaderCell
      
      cell.title.text = "COL \(indexPath.row)"
      
      return cell
      
    case (0, _):
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "columnHeader", forIndexPath: indexPath
        ) as! ColumnHeaderCell
      
      cell.title.text = "ROW \(indexPath.section)"
      
      return cell
      
      //
      
    default:
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "rowContent", forIndexPath: indexPath
        ) as! RowContentCell
      
      cell.title.text = String(arc4random_uniform(100))
      
      return cell
    }
  }
}

extension CollectionViewController: SpreadsheetLayoutDelegate {
  func width(forColumn column: UInt, collectionView: UICollectionView) -> CGFloat {
    return columnHeaderSizingCell.frame.width
  }
  
  func height(forRow row: UInt, collectionView: UICollectionView) -> CGFloat {
    switch row {
    case 0:
      return columnHeaderSizingCell.frame.height
    default:
      return rowContentSizingCell.frame.height
    }
  }
}
