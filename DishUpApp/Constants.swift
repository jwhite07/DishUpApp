//
//  Constants.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import Foundation
struct GlobalConstants{
    struct API {
        static let url = "https://dishupapp.herokuapp.com/api/"
        static let key = "abc"
    }
    
}
var imageCache = NSCache()
var dishCache : [Int:Dish] = [:]
var tagCache : [Int:Int] = [:]

