//
//  Restaurant.swift
//  DishUpApp
//
//  Created by James White on 7/30/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class Restaurant{
    let name: String
    let address: String
    let city: String
    let state: String
    let country: String?
    let postal_code: String?
    let logo: String?
    let premium_level: String?
    let phone_number: String?
    let website: String?
    let distance: Float?
    
    let id: Int
    
    
    
    required init( json: JSON) {
        
        self.name = json["name"].stringValue
        self.address = json["address"].stringValue
        self.city = json["city"].stringValue
        self.state = json["state"].stringValue
        self.country = json["country"].string
        self.postal_code = json["postal_code"].string
        self.logo = json["logo"].string
        self.premium_level = json["premium_level"].string
        self.phone_number = json["phone_number"].string
        self.website = json["website"].string
        self.distance = json["distance"].float
        self.id = json["id"].intValue
    }
    
}