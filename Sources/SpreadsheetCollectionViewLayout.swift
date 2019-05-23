//
//  SpreadsheetLayout.swift
//  SpreadsheetLayout
//
//  Created by Jose Martinez on 12/15/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: SpreadsheetCollectionViewLayoutDelegate!
    
    private var layoutAttributesCache: [UICollectionViewLayoutAttributes]!
    private var layoutAttributesInRectCache = CGRect.zero
    private var contentSizeCache = CGSize.zero
    private var columnCountCache = 0
    private var rowCountCache = 0
    
    // Saves the starting offset of the collection view. This offset will be applied to the rect of
    // each cell to find the true origin. For example, this project contains a navigation bar which 
    // has a height of 64 points. This means that the true origin of the collection view is 
    // `CGPoint(x: 0, y: -64)`.
    private var originalContentOffset = CGPoint.zero
    
    override var collectionViewContentSize: CGSize {
        guard contentSizeCache.equalTo(CGSize.zero) else {
            return contentSizeCache
        }
        
        // Query the collection view's offset here. This method is executed exactly once.
        originalContentOffset = collectionView!.contentOffset
        columnCountCache = collectionView!.numberOfItems(inSection: 0)
        rowCountCache = collectionView!.numberOfSections
        
        var contentSize = CGSize(width: originalContentOffset.x, height: originalContentOffset.y)
        
        // Calculate the content size by querying the delegate. Perform this function only once.
        for column in 0..<columnCountCache {
            contentSize.width += delegate.width(
                forColumn: column, collectionView: collectionView!
            )
        }
        
        for row in 0..<rowCountCache {
            contentSize.height += delegate.height(
                forRow: row, collectionView: collectionView!
            )
        }
        
        contentSizeCache = contentSize
        
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let itemSize = CGSize(
            width: delegate.width(
                forColumn: indexPath.row, collectionView: collectionView!
            ),
            height: delegate.height(
                forRow: indexPath.section, collectionView: collectionView!
            )
        )
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
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
        attributes.frame = frame.integral
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard !rect.equalTo(layoutAttributesInRectCache) else {
            return layoutAttributesCache
        }
        
        layoutAttributesInRectCache = rect
        
        var attributes = Set<UICollectionViewLayoutAttributes>()
        
        for column in 0..<columnCountCache {
            for row in 0..<rowCountCache {
                let attribute = layoutAttributesForItem(at: IndexPath(row: column, section: row))!
                
                attributes.insert(attribute)
            }
        }
        
        layoutAttributesCache = Array(attributes)
        
        return layoutAttributesCache
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        layoutAttributesCache = nil
        layoutAttributesInRectCache = CGRect.zero
    }
}
