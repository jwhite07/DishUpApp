//
//  Dish.swift
//  DishUpApp
//
//  Created by James White on 7/21/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage



final class Dish {
    let name: String
    let price: NSNumber?
    let rating: NSNumber
    let description: String?
    let id: Int
    let menuIds: [Int]
    let dishTypeIds: [Int]
    let lead_dishpic_url: String?
    var dishpics: [Dishpic]
    var restaurant: Restaurant?
    
    
    required init( json: JSON) {
        self.name           = json["name"].stringValue
        self.description    = json["description"].string
        
        self.price          = json["price"].numberValue
        self.rating         = json["rating"].numberValue
        self.id             = json["id"].intValue
        self.dishTypeIds    = json["dish_type_ids"].arrayValue.map({$0.intValue})
        self.menuIds        = json["menu_ids"].arrayValue.map({$0.intValue})
        self.lead_dishpic_url = json["lead_dishpic_url"].string
        let prefetch = SDWebImagePrefetcher()
       
            prefetch.prefetchURLs([json["lead_dishpic_url"].stringValue])
        
        
        self.dishpics = []
        if let dishpics = json["dishpics"].arrayValue as [JSON]?{
            self.dishpics = dishpics.map({ Dishpic(json: $0) })
            prefetch.prefetchURLs(dishpics.map({$0["url"].stringValue}))
        }//
    
        if let restaurantJson = json["location"] as JSON?{
            
                self.restaurant = Restaurant(json: restaurantJson)
            
        }
        
    }
    //static func init_or_load( json: JSON)
    
}