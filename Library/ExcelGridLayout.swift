//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class ExcelGridLayout: UICollectionViewLayout {
  weak var delegate: ExcelGridLayoutDelegate!
  
  private var layoutAttributesCache: [UICollectionViewLayoutAttributes]!
  private var layoutAttributesInRectCache = CGRectZero
  private var contentSizeCache = CGSizeZero
  
  override func collectionViewContentSize() -> CGSize {
    guard CGSizeEqualToSize(contentSizeCache, CGSizeZero) else {
      return contentSizeCache
    }
    
    let columnCount = collectionView!.numberOfItemsInSection(0)
    let rowCount = collectionView!.numberOfSections()
    var contentSize = CGSizeZero
    
    for column in 0..<columnCount {
      contentSize.width += delegate.width(forColumn: UInt(column), collectionView: collectionView!)
    }
    
    for row in 0..<rowCount {
      contentSize.height += delegate.height(forRow: UInt(row), collectionView: collectionView!)
    }
    
    contentSizeCache = contentSize
    
    return contentSize
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let itemSize = CGSize(
      width: delegate.width(forColumn: UInt(indexPath.row), collectionView: collectionView!),
      height: delegate.height(forRow: UInt(indexPath.section), collectionView: collectionView!)
    )
    
    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    
    attributes.frame = CGRectIntegral(
      CGRect(
        x: itemSize.width * CGFloat(indexPath.row),
        y: itemSize.height * CGFloat(indexPath.section),
        width: itemSize.width,
        height: itemSize.height
      )
    )
    
    // Set this value for the first item (Sec0Row0) in order to make it visible over first column
    // and first row
    if indexPath.section == 0 && indexPath.row == 0 {
      attributes.zIndex = 1024
    }
      
      // Set this value for the first row or section in order to set visible over the rest of the items
    else if indexPath.section == 0 || indexPath.row == 0 {
      attributes.zIndex = 1023
    }
    
    if indexPath.section == 0 {
      var frame = attributes.frame
      frame.origin.y = collectionView!.contentOffset.y
      attributes.frame = frame
    }
    
    if indexPath.row == 0 {
      var frame = attributes.frame
      frame.origin.x = collectionView!.contentOffset.x
      attributes.frame = frame
    }
    
    return attributes
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard !CGRectEqualToRect(rect, layoutAttributesInRectCache) else {
      return layoutAttributesCache
    }
    
    layoutAttributesInRectCache = rect
    
    var attributes = Set<UICollectionViewLayoutAttributes>()
    
    for section in 0..<collectionView!.numberOfSections() {
      let itemCount = collectionView!.numberOfItemsInSection(section)
      
      for index in 0..<itemCount {
        let attribute = layoutAttributesForItemAtIndexPath(
          NSIndexPath(forItem: index, inSection: section)
          )!
        
        attributes.insert(attribute)
      }
    }
    
    layoutAttributesCache = Array(attributes)
    
    return layoutAttributesCache
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func invalidateLayout() {
    super.invalidateLayout()
    
    layoutAttributesCache = nil
    layoutAttributesInRectCache = CGRectZero
  }
}
