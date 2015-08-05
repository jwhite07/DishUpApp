//
//  DishTypeCollectionViewCell.swift
//  DishUpApp
//
//  Created by James White on 7/17/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit

class DishTypeCollectionViewCell: UICollectionViewCell {
    weak var dishType : DishType?
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var label: UILabel!
    @IBAction func dishTypeTapped(var sender: AnyObject) {
        sender = dishType!
    }
}
