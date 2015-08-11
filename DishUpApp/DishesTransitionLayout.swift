//
//  DishesTransitionLayout.swift
//  DishUpApp
//
//  Created by James White on 8/10/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishesTransitionLayout: UICollectionViewTransitionLayout {
    var horizontalInset     = 0.0 as CGFloat
    var verticalInset       = 0.0 as CGFloat
    var minimumItemWidth    = 0.0 as CGFloat
    var maximumItemWidth    = 0.0 as CGFloat
    var itemHeight          = 0.0 as CGFloat
    var totalItems          = 0
    var gridSpacing         = 10.0 as CGFloat
    var itemsPerRow      = 3 as CGFloat
    
    //    var layoutMode          = .Single as LayoutMode
    
    var frameHeight         = 600 as CGFloat
    var frameWidth          = 600 as CGFloat
    var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var _contentSize = CGSizeZero
    var cache = [UICollectionViewLayoutAttributes]()
    override func prepareLayout() {
        
        var prog : CGFloat = 0
        
        if layoutMode == .Single{
            prog = 1 - transitionProgress
        }else{
            prog = transitionProgress
        }
        //print("layoutMode: \(layoutMode) prog: \(prog) transition Progress: \(transitionProgress)")
        frameHeight = self.collectionView!.frame.size.height
        frameWidth = self.collectionView!.frame.size.width
        
        let numberOfSections : Int
        let numberOfItems : Int
        var spacing : CGFloat = 0
        
        
        numberOfSections = 1
        numberOfItems = self.collectionView!.numberOfItemsInSection(0)
        
        
        
        for var section = 0; section < numberOfSections; section++ {
            var xOffset = 0.0 as CGFloat
            var yOffset = 0.0 as CGFloat
            var contentWidth : CGFloat = 0
            let itemSizeGrid = calculateItemSize(itemsPerRow)
            let itemSizeSingle = CGSizeMake(frameWidth, frameHeight)
            
            
            let itemSize = CGSizeMake(
                (itemSizeSingle.width - itemSizeGrid.width) * prog + itemSizeGrid.width,
                (itemSizeSingle.height - itemSizeGrid.height) * prog + itemSizeGrid.height
            )
            
            spacing = gridSpacing * (1 - prog)
            
            xOffset = spacing
            yOffset = spacing
            var rowCount = 0
            for var item = 0; item < numberOfItems; item++ {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.zIndex = numberOfItems - item
                //print("indexPath Row: \(indexPath.row)")
                var increaseRow = false
                
                if rowCount == 2  {
                    increaseRow = true
                    contentWidth = xOffset + itemSize.width + spacing
                    
                }
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                cache.append(attributes)
                if increaseRow == true {
                    xOffset = spacing
                    yOffset += itemSize.height
                    yOffset += spacing
                    increaseRow = false
                    rowCount = 0
                }else{
                    xOffset += itemSize.width
                    xOffset += spacing
                    rowCount += 1
                }
            }
            if contentWidth == 0{
                contentWidth = xOffset
            }
            yOffset += itemSize.height
            yOffset += spacing
            //print("xOffset: \(xOffset) yOffset: \(yOffset)")
            _contentSize = CGSizeMake(contentWidth, yOffset)
            //print("Layout Attributes: \(_layoutAttributes)")
            
        }
    }
    func calculateItemSize ( itemsPerRow: CGFloat) -> CGSize{
        let size : CGFloat
        size = (frameWidth - gridSpacing * (itemsPerRow + 1))  / itemsPerRow
        return CGSize(width: size, height: size)
    }
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    override func collectionViewContentSize() -> CGSize {
        
        return _contentSize
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        for att in cache{
            if att.indexPath == indexPath{
                return att
            }
        }
        return nil
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        print("rect: \(rect) content size: \(_contentSize)")
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
}
