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
  
  private var layoutAttributesCache: [[UICollectionViewLayoutAttributes]]!
  private var layoutRectCache = CGRectZero
  private var itemsSize = [CGSize]()
  private var contentSize: CGSize!
  
  override func prepareLayout() {
    super.prepareLayout()
    
    guard let cv = collectionView where cv.numberOfSections() > 0 else {
      return
    }
    
    if layoutAttributesCache != nil && layoutAttributesCache.count > 0 {
      
      for section in 0..<cv.numberOfSections() {
        let itemCount = cv.numberOfItemsInSection(section)
        
        for index in 0..<itemCount {
          if section != 0 && index != 0 {
            continue
          }
          
          let attributes = layoutAttributesForItemAtIndexPath(
            NSIndexPath(forItem: index, inSection: section)
            )!
          
          if section == 0 {
            var frame = attributes.frame
            frame.origin.y = cv.contentOffset.y
            attributes.frame = frame
          }
          
          if index == 0 {
            var frame = attributes.frame
            frame.origin.x = cv.contentOffset.x
            attributes.frame = frame
          }
        }
      }
      return
    }
    
    let columnCount = delegate.numberOfColumnsInCollectionView(cv, layout: self)
    
    if itemsSize.count != columnCount {
      
      for index in 0..<columnCount {
        itemsSize.append(
          delegate.collectionView(
            cv, layout: self, sizeForItemAtColumn: UInt(index)
          )
        )
      }
    }
    
    var column = 0
    var xOffset : CGFloat = 0
    var yOffset : CGFloat = 0
    var contentWidth : CGFloat = 0
    var contentHeight : CGFloat = 0
    
    for section in 0..<cv.numberOfSections() {
      var sectionAttributes = [UICollectionViewLayoutAttributes]()
      
      for index in 0..<columnCount {
        let itemSize = itemsSize[index]
        let indexPath = NSIndexPath(forItem: index, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(
          forCellWithIndexPath: indexPath
        )
        
        attributes.frame = CGRectIntegral(
          CGRect(
            x: xOffset,
            y: yOffset,
            width: itemSize.width,
            height: itemSize.height
          )
        )
        
        if section == 0 && index == 0 {
          attributes.zIndex = 1024;
        }
          
        else if section == 0 || index == 0 {
          attributes.zIndex = 1023
        }
        
        if section == 0 {
          var frame = attributes.frame
          frame.origin.y = cv.contentOffset.y
          attributes.frame = frame
        }
        
        if index == 0 {
          var frame = attributes.frame
          frame.origin.x = cv.contentOffset.x
          attributes.frame = frame
        }
        
        sectionAttributes.append(attributes)
        
        xOffset += itemSize.width
        column += 1
        
        if column == columnCount {
          if xOffset > contentWidth {
            contentWidth = xOffset
          }
          
          column = 0
          xOffset = 0
          yOffset += itemSize.height
        }
      }
      if layoutAttributesCache == nil {
        layoutAttributesCache = [[UICollectionViewLayoutAttributes]]()
      }
      layoutAttributesCache.append(sectionAttributes)
    }
    
    let attributes = layoutAttributesCache.last?.last
    contentHeight = attributes!.frame.origin.y + attributes!.frame.size.height
    contentSize =  CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func collectionViewContentSize() -> CGSize {
    return contentSize
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard layoutAttributesCache.count > indexPath.section && layoutAttributesCache[indexPath.section].count > indexPath.row else {
      assertionFailure("Index out of bounds")
      return nil
    }
    
    return layoutAttributesCache[indexPath.section][indexPath.row]
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    if CGRectEqualToRect(rect, layoutRectCache) {
//      return layoutAttributesCache
//    }
    
    var attributes = [UICollectionViewLayoutAttributes]()
    
    if layoutAttributesCache != nil {
      for section in layoutAttributesCache {
        
        let filtered = section.filter {
          obj in return CGRectIntersectsRect(rect, obj.frame)
        }
        
        attributes.appendContentsOf(filtered)
      }
    }
    
    return attributes
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func invalidateLayout() {
    super.invalidateLayout()
  }
}
