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
    var dishContentMode : UIViewContentMode = .ScaleAspectFit
    
    @IBOutlet weak var dishPic: UIImageView!
    var dishIndex : Int?
    
}
