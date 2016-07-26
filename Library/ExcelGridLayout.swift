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
  
  var itemAttributes: [[UICollectionViewLayoutAttributes]]!
  var itemsSize = [CGSize]()
  var contentSize: CGSize!
  
  override func prepareLayout() {
    guard collectionView?.numberOfSections() > 0 else {
      return
    }
    
    if itemAttributes != nil && itemAttributes.count > 0 {
      
      for section in 0..<collectionView!.numberOfSections() {
        let numberOfItems = collectionView!.numberOfItemsInSection(section)
        for index in 0..<numberOfItems {
          if section != 0 && index != 0 {
            continue
          }
          
          let attributes = layoutAttributesForItemAtIndexPath(
            NSIndexPath(forItem: index, inSection: section)
            )!
          
          if section == 0 {
            var frame = attributes.frame
            frame.origin.y = self.collectionView!.contentOffset.y
            attributes.frame = frame
          }
          
          if index == 0 {
            var frame = attributes.frame
            frame.origin.x = self.collectionView!.contentOffset.x
            attributes.frame = frame
          }
        }
      }
      return
    }
    
    let numberOfColumns = delegate.numberOfColumnsInCollectionView(
      collectionView!, layout: self
    )
    
    if (itemsSize.count != numberOfColumns) {

      for index in 0..<numberOfColumns {
        itemsSize.append(delegate.collectionView(
          collectionView!, layout: self, sizeForItemAtColumn: UInt(index))
        )
      }
    }
    
    var column = 0
    var xOffset : CGFloat = 0
    var yOffset : CGFloat = 0
    var contentWidth : CGFloat = 0
    var contentHeight : CGFloat = 0
    
    for section in 0..<collectionView!.numberOfSections() {
      var sectionAttributes = [UICollectionViewLayoutAttributes]()
      
      for index in 0..<numberOfColumns {
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
          frame.origin.y = self.collectionView!.contentOffset.y
          attributes.frame = frame
        }
        
        if index == 0 {
          var frame = attributes.frame
          frame.origin.x = self.collectionView!.contentOffset.x
          attributes.frame = frame
        }
        
        sectionAttributes.append(attributes)
        
        xOffset += itemSize.width
        column += 1
        
        if column == numberOfColumns {
          if xOffset > contentWidth {
            contentWidth = xOffset
          }
          
          column = 0
          xOffset = 0
          yOffset += itemSize.height
        }
      }
      if itemAttributes == nil {
        self.itemAttributes = [[UICollectionViewLayoutAttributes]]()
      }
      self.itemAttributes.append(sectionAttributes)
    }
    
    let attributes = itemAttributes.last?.last
    contentHeight = attributes!.frame.origin.y + attributes!.frame.size.height
    contentSize =  CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func collectionViewContentSize() -> CGSize {
    return contentSize
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return itemAttributes[indexPath.section][indexPath.row]
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributes = [UICollectionViewLayoutAttributes]()
    
    if itemAttributes != nil {
      for section in self.itemAttributes {
        
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
}
