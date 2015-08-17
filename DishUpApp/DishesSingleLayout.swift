//
//  DishesSingleLayout.swift
//  DishUpApp
//
//  Created by James White on 8/9/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishesSingleLayout: UICollectionViewLayout {
    var horizontalInset     = 0.0 as CGFloat
    var verticalInset       = 0.0 as CGFloat
    var minimumItemWidth    = 0.0 as CGFloat
    var maximumItemWidth    = 0.0 as CGFloat
    var itemHeight          = 0.0 as CGFloat
    var totalItems          = 0
    var gridSpacing         = 10.0 as CGFloat
    var maxItemsPerRow      = 4 as CGFloat
    
    //    var layoutMode          = .Single as LayoutMode
    
    var frameHeight         = 600 as CGFloat
    var frameWidth          = 600 as CGFloat
    var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var _contentSize = CGSizeZero
    var cache = [UICollectionViewLayoutAttributes]()
    
    
    override func prepareLayout() {
        cache = []
        super.prepareLayout()
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
            var itemSize = CGSizeZero
            for var item = 0; item < numberOfItems; item++ {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.zIndex = numberOfItems - item
                
                itemSize.height = frameHeight
                itemSize.width = frameWidth
                
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                cache.append(attributes)
                xOffset += itemSize.width
                xOffset += spacing
            }
            if contentWidth == 0{
                contentWidth = xOffset
            }
            yOffset += itemSize.height
            yOffset += spacing
            _contentSize = CGSizeMake(contentWidth, yOffset)
            
        }
        
    }
//    override func finalizeLayoutTransition() {
//        if let  att = self.layoutAttributesForItemAtIndexPath(currentIndexPath){
//            print("final offset: \(att.frame.origin)")
//            self.collectionView?.contentOffset = att.frame.origin
//        }
//
//        
//    }

    
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    override func collectionViewContentSize() -> CGSize {
        
        return _contentSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        for att in cache{
            if att.indexPath == indexPath{
                //print("indexPath: \(indexPath) att: \(att)")
                return att
            }
            
        }
        return nil
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
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
