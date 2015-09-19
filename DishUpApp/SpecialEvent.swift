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

final class SpecialEvent{
    let name: String
    let id: Int
    //let start_date: NSDate
    //let end_date: NSDate
    
    
    
    required init( json: JSON) {
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
    }
    
}