//
//  RestaurantCell.swift
//  DishUpApp
//
//  Created by James White on 7/30/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    weak var restaurant : Restaurant?
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantCitySt: UILabel!
    @IBOutlet weak var restaurantImg: UIImageView!
    
    @IBOutlet weak var restaurantDistance: UILabel!
}
