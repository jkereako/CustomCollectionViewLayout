//
//  CollectionViewController.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  private var dateSizingCell: DateCollectionViewCell!
  private var contentSizingCell: ContentCollectionViewCell!
  
  let dateCellIdentifier = "DateCellIdentifier"
  let contentCellIdentifier = "ContentCellIdentifier"
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dateNib = UINib(nibName: "DateCollectionViewCell", bundle: nil)
    let contentNib = UINib(nibName: "ContentCollectionViewCell", bundle: nil)
    
    collectionView.registerNib(dateNib, forCellWithReuseIdentifier: dateCellIdentifier)
    collectionView.registerNib(contentNib, forCellWithReuseIdentifier: contentCellIdentifier)
    
    dateSizingCell = dateNib.instantiateWithOwner(nil, options: nil).first as! DateCollectionViewCell
    contentSizingCell = contentNib.instantiateWithOwner(nil, options: nil).first as! ContentCollectionViewCell
    
    let layout = collectionView.collectionViewLayout as! ExcelGridLayout
    layout.delegate = self
  }
  
  // MARK - UICollectionViewDataSource
  // i.e. number of rows
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 50
  }
  
  // i.e. number of columns
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 8
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let dateCell = collectionView.dequeueReusableCellWithReuseIdentifier(
          dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
        
        dateCell.backgroundColor = UIColor.whiteColor()
        dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
        dateCell.dateLabel.textColor = UIColor.blackColor()
        dateCell.dateLabel.text = "Date"
        
        return dateCell
      }
        
      else {
        let contentCell = collectionView.dequeueReusableCellWithReuseIdentifier(
          contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
        
        contentCell.contentLabel.font = UIFont.systemFontOfSize(13)
        contentCell.contentLabel.textColor = UIColor.blackColor()
        contentCell.contentLabel.text = "Column \(indexPath.row)"
        
        if indexPath.section % 2 != 0 {
          contentCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
          contentCell.backgroundColor = UIColor.whiteColor()
        }
        
        return contentCell
      }
    }
      
    else {
      if indexPath.row == 0 {
        let dateCell = collectionView.dequeueReusableCellWithReuseIdentifier(
          dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
        
        dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
        dateCell.dateLabel.textColor = UIColor.blackColor()
        dateCell.dateLabel.text = String(indexPath.section)
        if indexPath.section % 2 != 0 {
          dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        }
          
        else {
          dateCell.backgroundColor = UIColor.whiteColor()
        }
        
        return dateCell
      }
        
      else {
        let contentCell = collectionView.dequeueReusableCellWithReuseIdentifier(
          contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
        
        contentCell.contentLabel.font = UIFont.systemFontOfSize(13)
        contentCell.contentLabel.textColor = UIColor.blackColor()
        contentCell.contentLabel.text = "Content"
        
        if indexPath.section % 2 != 0 {
          contentCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        }
          
        else {
          contentCell.backgroundColor = UIColor.whiteColor()
        }
        
        return contentCell
      }
    }
  }
}

extension CollectionViewController: ExcelGridLayoutDelegate {
  func width(forColumn column: UInt, collectionView: UICollectionView) -> CGFloat {
    return dateSizingCell.frame.width
  }
  
  func height(forRow row: UInt, collectionView: UICollectionView) -> CGFloat {
    switch row {
    case 0:
      return dateSizingCell.frame.height
    default:
      return contentSizingCell.frame.height
    }
  }
}
