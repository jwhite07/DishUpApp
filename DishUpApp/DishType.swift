//
//  DishType.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class DishType{
    let name: String
    let id: Int
    let description: String?
    let icon_url: String?
    
    
    
    required init( json: JSON) {
        self.description = json["description"].string
        self.name = json["name"].stringValue
        self.icon_url = json["icon_url"].string
        self.id = json["id"].intValue
        if (self.icon_url  != nil){
            
            Networking.getImageAtUrl( self.icon_url!)
        }
    }
    
}