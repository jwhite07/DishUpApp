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
    
    @IBOutlet weak var dishPic: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishRating: CosmosView!
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var rightArrow: UIButton!
    var dishIndex : Int?
    @IBAction func rightArrowTap(sender: AnyObject) {
        
    }
    @IBOutlet weak var leftArrow: UIButton!
    @IBAction func leftArrowTap(sender: AnyObject) {
        
    }
    
//    @IBOutlet weak var dragHandle: UIView!
    //@IBOutlet weak var dishDesc: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
//    let dragHandleUp = UIScreenEdgePanGestureRecognizer()
//    let dragHandleDown = UIPanGestureRecognizer()

    
}
