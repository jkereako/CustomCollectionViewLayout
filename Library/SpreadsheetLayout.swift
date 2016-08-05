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
  private var columnCountCache = 0
  private var rowCountCache = 0
  
  // Saves the starting offset of the collection view. This offset will be applied to the rect of
  // each cell to find the true origin. For example, this project contains a navigation bar which 
  // has a height of 64 points. This means that the true origin of the collection view is 
  // `CGPoint(x: 0, y: -64)`.
  private var originalContentOffset = CGPointZero
  
  override func collectionViewContentSize() -> CGSize {
    guard CGSizeEqualToSize(contentSizeCache, CGSizeZero) else {
      return contentSizeCache
    }
    
    // Query the collection view's offset here. This method is executed exactly once.
    originalContentOffset = collectionView!.contentOffset
    columnCountCache = collectionView!.numberOfItemsInSection(0)
    rowCountCache = collectionView!.numberOfSections()
    
    var contentSize = CGSize(width: originalContentOffset.x, height: originalContentOffset.y)
    
    // Calculate the content size by querying the delegate. Perform this function only once.
    for column in 0..<columnCountCache {
      contentSize.width += delegate.width(forColumn: UInt(column), collectionView: collectionView!)
    }
    
    for row in 0..<rowCountCache {
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
    
    // Calculate the rect of the cell making sure to incorporate the off set of the collection
    // view's content.
    var frame = CGRect(
      x: (itemSize.width * CGFloat(indexPath.row)) + originalContentOffset.x,
      y: (itemSize.height * CGFloat(indexPath.section)) + originalContentOffset.y,
      width: itemSize.width,
      height: itemSize.height
    )
    
    // Creates a tuple type out of an index path. This is a prime example of pattern matching.
    // see: https://en.wikipedia.org/wiki/Pattern_matching
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
    
    // For more information on what `CGRectIntegral` does and why we should use it, go here:
    // http://iosdevelopertip.blogspot.in/2014/10/cgrectintegral.html
    attributes.frame = CGRectIntegral(frame)
    
    return attributes
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard !CGRectEqualToRect(rect, layoutAttributesInRectCache) else {
      return layoutAttributesCache
    }
    
    layoutAttributesInRectCache = rect
    
    var attributes = Set<UICollectionViewLayoutAttributes>()

    for column in 0..<columnCountCache {
      for row in 0..<rowCountCache {
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
