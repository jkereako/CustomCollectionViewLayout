//
//  SpreadsheetLayout.swift
//  SpreadsheetLayout
//
//  Created by Jose Martinez on 12/15/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetLayout: UICollectionViewLayout {
  weak var delegate: SpreadsheetLayoutDelegate!
  
  private var layoutAttributesCache: [UICollectionViewLayoutAttributes]!
  private var layoutAttributesInRectCache = CGRectZero
  private var contentSizeCache = CGSizeZero
  private var columnCount = 0
  private var rowCount = 0
  private var contentOffset = CGPointZero
  
  override func prepareLayout() {
    super.prepareLayout()
    
    columnCount = collectionView!.numberOfItemsInSection(0)
    rowCount = collectionView!.numberOfSections()
  }
  
  override func collectionViewContentSize() -> CGSize {
    guard CGSizeEqualToSize(contentSizeCache, CGSizeZero) else {
      return contentSizeCache
    }
    
    contentOffset = collectionView!.contentOffset
    var contentSize = CGSize(width: contentOffset.x, height: contentOffset.y)
    
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

    var frame = CGRectIntegral(
      CGRect(
        x: (itemSize.width * CGFloat(indexPath.row)) + contentOffset.x,
        y: (itemSize.height * CGFloat(indexPath.section)) + contentOffset.y,
        width: itemSize.width,
        height: itemSize.height
      )
    )
    
    switch (indexPath.section, indexPath.row) {
    // Top-left tem
    case (0, 0):
      attributes.zIndex = 2
      frame.origin.y = collectionView!.contentOffset.y
      frame.origin.x = collectionView!.contentOffset.x
      
    // Top row
    case (0, _):
      attributes.zIndex = 1
      frame.origin.y = collectionView!.contentOffset.y
      
    // Left column
    case (_, 0):
      attributes.zIndex = 1
      frame.origin.x = collectionView!.contentOffset.x
      
    default:
      attributes.zIndex = 0
    }
    
    attributes.frame = frame
    
    return attributes
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard !CGRectEqualToRect(rect, layoutAttributesInRectCache) else {
      return layoutAttributesCache
    }
    
    layoutAttributesInRectCache = rect
    
    var attributes = Set<UICollectionViewLayoutAttributes>()

    for column in 0..<columnCount {
      for row in 0..<rowCount {
        let attribute = layoutAttributesForItemAtIndexPath(
          NSIndexPath(forItem: column, inSection: row)
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
