//
//  File.swift
//  DishUpApp
//
//  Created by James White on 7/31/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class Dishpic {
    let dish_id: Int
    let favorites: Int
    let user_id: Int?
    let caption: String?
    let quality_score: NSNumber
    let url: String
    let id: Int
    let user_name: String?
    
    
    required init( json: JSON) {
        self.dish_id            = json["dish_id"].intValue
        self.favorites          = json["favorites"].intValue
        self.user_id            = json["user_id"].int
        self.caption            = json["caption"].string
        self.id                 = json["id"].intValue
        self.quality_score      = json["quality_score"].numberValue
        self.url                = json["url"].stringValue
        self.user_name          = json["user"]["name"].string
    }
}