//
//  DishesGridLayout.swift
//  DishUpApp
//
//  Created by James White on 8/9/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishesGridLayout: UICollectionViewLayout {
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
            
            
            spacing = gridSpacing
            
            xOffset = spacing
            yOffset = spacing
            itemSize = calculateItemSize(maxItemsPerRow)
            let maxItems = calculateItemsPerScreen(itemSize)
            
            if numberOfItems < maxItems{
                var itemsPerScreenArray = [Int](count: Int(maxItemsPerRow), repeatedValue: 0)
                var sizeArray = [CGSize](count: Int(maxItemsPerRow), repeatedValue: CGSizeZero)
                itemsPerScreenArray[Int(maxItemsPerRow) - 1] = maxItems
                sizeArray[Int(maxItemsPerRow) - 1] = itemSize
                for var row = Int(maxItemsPerRow) - 2; row >= 0; row-- {
                    sizeArray[row] = calculateItemSize(CGFloat(row+1))
                    itemsPerScreenArray[row] = calculateItemsPerScreen(sizeArray[row])
                    if itemsPerScreenArray[row] / 2 < numberOfItems {
                        itemSize = sizeArray[row]
                        break
                    }
                    
                }
            }
                
            
            
            
            
            
            for var item = 0; item < numberOfItems; item++ {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.zIndex = numberOfItems - item
                print("indexPath Row: \(indexPath.row)")
                var increaseRow = false
                
                if ((frameWidth - spacing - xOffset) < (itemSize.width + 1) && item != numberOfItems - 1)  {
                    increaseRow = true
                    contentWidth = xOffset + itemSize.height + spacing
                    
                }
                
                    
                
                print("xOffset: \(xOffset) yOffset: \(yOffset) item Width: \(itemSize.width) Item Height: \(itemSize.height)")
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                
                cache.append(attributes)
                
                if increaseRow == true {
                    xOffset = spacing
                    yOffset += itemSize.height
                    yOffset += spacing
                    increaseRow = false
                }else{
                    xOffset += itemSize.width
                    xOffset += spacing
                }
                
                
                
            }
            if contentWidth == 0{
                contentWidth = xOffset
            }
            yOffset += itemSize.height
            yOffset += spacing
            print("xOffset: \(xOffset) yOffset: \(yOffset)")
            _contentSize = CGSizeMake(contentWidth, yOffset)
            print("Layout Attributes: \(_layoutAttributes)")
            
        }
        
    }
    func calculateItemsPerScreen (itemSize: CGSize) -> Int{
        let size = itemSize.width
        let columns = Int((frameWidth - gridSpacing) / (size + gridSpacing))
        
        let rows = Int(floor((frameHeight - gridSpacing) / (size + gridSpacing)))
        
        return columns * rows
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

