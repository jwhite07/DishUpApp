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
        cache = []
        var prog : CGFloat = 0
        
        if layoutMode == .Single{
            prog = 1 - transitionProgress
        }else{
            prog = transitionProgress
        }
        let invProg = 1 - prog
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
            
            spacing = gridSpacing * invProg
            
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
        let currentObj = cache[currentIndexPath.item]
        
        _contentSize.width + frameWidth + currentObj.size.width
        _contentSize.height + frameHeight + currentObj.size.height
        let c = _contentSize
        let oldOffset = self.collectionView!.contentOffset
        let f = CGSizeMake(frameWidth, frameHeight)
        let o = currentObj
        let os = o.size
        var offset = CGPointMake(0,0)
        
        let xfill = f.width - os.width
        let leadSpace = o.frame.origin.x
        let trailSpace = c.width - (o.frame.origin.x + os.width)
        if xfill / 2 > leadSpace{
            offset.x = 0
        }else if xfill / 2 > trailSpace{
            offset.x = c.width - f.width
        }else{
            offset.x = o.frame.origin.x - (xfill / 2)
        }
        
        let yfill = f.height - os.height
        let topSpace = o.frame.origin.y
        let botSpace = c.height - (o.frame.origin.y + os.height)
        
        if yfill / 2 > topSpace{
            offset.y = 0
        }else if yfill / 2 > botSpace{
            offset.y = c.height - f.height
        }else{
            offset.y = o.frame.origin.y - (yfill / 2)
        }
//        if offset.x != oldOffset.x{
//            if offset.x > oldOffset.x{
//                offset.x = oldOffset.x + (offset.x - oldOffset.x) / 2
//            }else{
//                offset.x = offset.x + (oldOffset.x - offset.x) / 2
//            }
//        }
//        if offset.y != oldOffset.y{
//            if offset.y > oldOffset.y{
//                offset.y = oldOffset.y + (offset.y - oldOffset.y) / 2
//            }else{
//                offset.y = offset.y + (oldOffset.y - offset.y) / 2
//            }
//        }
        
        self.collectionView!.contentOffset = offset;
        targetGridOffset = offset
        
        
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
       // print("rect: \(rect) content size: \(_contentSize)")
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
