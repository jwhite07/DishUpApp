//
//  DishCollectionViewCell.swift
//  DishUpApp
//
//  Created by James White on 7/21/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import Cosmos
class DishCollectionViewCell: UICollectionViewCell {
    weak var dish: Dish?
    weak var indexPath: NSIndexPath?
    weak var collectionView: UICollectionView?
    
    @IBOutlet weak var dishPic: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishRating: CosmosView!
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var rightArrow: UIButton!
    var dishIndex : Int?
    @IBAction func rightArrowTap(sender: AnyObject) {
        self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem:indexPath!.row + 1, inSection:indexPath!.section),
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: true)
    
    }
    @IBOutlet weak var leftArrow: UIButton!
    @IBAction func leftArrowTap(sender: AnyObject) {
        self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem:indexPath!.row - 1, inSection:indexPath!.section),
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: true)

    }
    
//    @IBOutlet weak var dragHandle: UIView!
    //@IBOutlet weak var dishDesc: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
//    let dragHandleUp = UIScreenEdgePanGestureRecognizer()
//    let dragHandleDown = UIPanGestureRecognizer()

//    override func prepareForReuse() {
////        self.hidden = true
//        
//        self.dishPic = nil
//        self.dishName = nil
//        self.dishRating = nil
//        self.infoPanel = nil
//        self.rightArrow = nil
//        self.leftArrow = nil
//        self.dishIndex = nil
//        self.leftArrow = nil
//        self.dishPrice = nil
//        self.dish = nil
//        self.indexPath = nil
//        self.collectionView = nil
//    }
}
