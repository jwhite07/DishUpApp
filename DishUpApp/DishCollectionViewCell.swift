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
    var hideLeftArrow: Bool? = false
    var hideRightArrow: Bool? = false
    
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
    
    @IBOutlet weak var dishPrice: UILabel!
    func hideForGrid(){
//        self.dishName.hidden = true
//        self.dishPrice.hidden = true
        self.infoPanel.hidden = true
        self.rightArrow.hidden = true
        self.leftArrow.hidden = true
        
//        for c in self.infoPanel.constraints {
//            if c.identifier == "infoPanelHeight"{
//                c.constant = 12
//            }
//        }
        
    }
    func showForGrid(){
//        self.dishName.hidden = false
//        self.dishPrice.hidden = false
        self.infoPanel.hidden = false
        if hideRightArrow! == false{
            self.rightArrow.hidden = false
        }
        if hideLeftArrow! == false{
            self.leftArrow.hidden = false
        }
        
//        for c in self.infoPanel.constraints {
//            if c.identifier == "infoPanelHeight"{
//                c.constant = 135
//            }
//        }


    }
}
