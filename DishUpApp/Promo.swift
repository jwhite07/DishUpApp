//
//  Promo.swift
//  DishUpApp
//
//  Created by James White on 10/30/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class Promo{
    let name: String
    let id: Int
    let action: String
    let img: String?
    let message: String?
    let title_color: String?
    let body_color: String?
    let restaurant_id: Int?
    let menu_id: Int?
    let special_event_id: Int?
    let dish_type_id: Int?
    let url: String?
    let distance: Float?
    //let start_date: NSDate
    //let end_date: NSDate
    
    
    
    required init( json: JSON) {
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
        self.img = json["img"].string
        self.message = json["message"].string
        self.title_color = json["title_color"].string
        self.body_color = json["body_color"].string
        self.restaurant_id = json["restaurant_id"].int
        self.special_event_id = json["special_event_id"].int
        self.dish_type_id = json["dish_type_id"].int
        self.url = json["link_url"].string
        self.distance = json["distance"].float
        self.action = json["action"].stringValue
        self.menu_id = json["menu_id"].int

    }
    
}