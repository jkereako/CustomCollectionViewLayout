//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

class ExcelGridLayout: UICollectionViewLayout {
  weak var delegate: ExcelGridLayoutDelegate!
  
  private var layoutAttributesCache: [UICollectionViewLayoutAttributes]!
  private var layoutAttributesInRectCache = CGRectZero
  private var contentSizeCache = CGSizeZero
  
  override func collectionViewContentSize() -> CGSize {
    if !CGSizeEqualToSize(contentSizeCache, CGSizeZero) {
      return contentSizeCache
    }
    
    guard let d = delegate, let cv = collectionView else {
      return CGSizeZero
    }
    
    let columnCount = cv.numberOfItemsInSection(0)
    let rowCount = cv.numberOfSections()
    
    var contentSize = CGSizeZero
    
    for column in 0..<columnCount {
      let itemSize = d.collectionView(cv, layout: self, sizeForItemAtColumn: UInt(column))
      contentSize.width += itemSize.width
    }
    
    contentSize.height = d.collectionView(cv, layout: self, sizeForItemAtColumn: 0).height * CGFloat(rowCount)
    
    contentSizeCache = contentSize
    
    return contentSize
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard let d = delegate, let cv = collectionView else {
      assertionFailure("Expected delegate and collection view")
      return nil
    }
    
    let itemSize = d.collectionView(cv, layout: self, sizeForItemAtColumn: UInt(indexPath.row))
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
      frame.origin.y = cv.contentOffset.y
      attributes.frame = frame
    }
    
    if indexPath.row == 0 {
      var frame = attributes.frame
      frame.origin.x = cv.contentOffset.x
      attributes.frame = frame
    }
    
    return attributes
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    if CGRectEqualToRect(rect, layoutAttributesInRectCache) {
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
