//
//  Networking.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    
    // static let manager = Manager.sharedInstance
    // Add API key header to all requests make with this manager (i.e., the whole session)
    
    // manager.session.configuration.HTTPAdditionalHeaders = ["X-DishUp-Key": "\(GlobalConstants.API.key)"]
    
    static func getDishTypes(requester: DishTypesVC, completion: (() -> ())? = nil){
        //
        Alamofire.request(.GET, "https://removed.com/api/dish_types")
            .responseJSON {(request, response, json, error)in
                if json != nil{
                    var jsonObj = JSON(json!)
                    if let dishtypes = jsonObj["dish_types"].arrayValue as [JSON]?{
                        
                        let dishTypesArray =  dishtypes.map({ DishType(json: $0) })
                        requester.dishTypesArray = dishTypesArray

                        completion?()
                    }
                }
        }

    }
    static func getDishes(requester: DishesVC, urlParent: String?, completion: (() -> ())? = nil){
        //
        var requestUrl : String
        requestUrl = GlobalConstants.API.url
        
        if let u = urlParent{
            requestUrl += u
        }
        requestUrl += "/dishes"
        print("Dishes Request url: \(requestUrl)")
        Alamofire.request(.GET, requestUrl)
            .response {(request, response, json, error) in
                print("Request: \(request) response: \(response) json: \(json) error: \(error)")
                if json != nil{
                    var jsonObj = JSON(json!)
                    if let dishes = jsonObj["dishes"].arrayValue as [JSON]?{
                        print(json)
                        let dishesArray = dishes.map({Dish(json: $0)})
                        requester.dishesArray = dishesArray
                        completion?()

                    }
                }
        }
        
    }

    static func getDishDetails(requester: DishDetailVC, dishId: Int, completion: (() -> ())? = nil){
        var requestUrl : String
        requestUrl = "\(GlobalConstants.API.url)dishes/\(dishId)"
        
       
        Alamofire.request(.GET, requestUrl)
            .responseJSON({(request, response, json, error)in
                print(json)
                if json != nil{
                    var jsonObj = JSON(json!)
                    if let dish = jsonObj["dish"] as JSON?{
                        print(json)
                        let dishObj = Dish(json: dish)
                        requester.dish = dishObj
                        completion?()
                        
                    }
                }
        })
    }
    static func getRestaurants(requester: RestaurantsVC, completion: (() -> ())? = nil){
        Alamofire.request(.GET, "\(GlobalConstants.API.url)restaurants")
            .response {(request, response, json, error)in
                if json != nil{
                    var jsonObj = JSON(json!)
                    if let restaurants = jsonObj["restaurants"].arrayValue as [JSON]?{
                        
                        let restaurantsArray =  restaurants.map({ Restaurant(json: $0) })
                        requester.restaurantsArray = restaurantsArray
                        
                        completion?()
                    }
                }
        }

    }
    
    static func getImageAtUrl (imageURL : String, completion: ((UIImage) -> ())? = nil) {
        
        if let imageObj = imageCache[imageURL]{
            
            
            completion?(imageObj)
        }else{
            Alamofire.request(.GET, imageURL).response() { (request, response, data, error) in
                print("Request: \(request) Response: \(response)")
                if error == nil{
                    print("Downloaded image from: \(imageURL)")
                    let imageObj = UIImage(data: data!)
                    imageCache[imageURL] = imageObj
                    completion?(imageObj!)

                }
            }
        }
    }
}
