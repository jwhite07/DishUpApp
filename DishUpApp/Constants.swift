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
let screenSize = UIScreen.mainScreen().bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
func delay(delay:Double, closure:()->()) {
    
    dispatch_after(
        dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    
    
}

