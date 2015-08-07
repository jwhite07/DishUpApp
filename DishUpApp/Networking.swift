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
import CoreLocation

class Networking {
    
    // static let manager = Manager.sharedInstance
    // Add API key header to all requests make with this manager (i.e., the whole session)
    
    // manager.session.configuration.HTTPAdditionalHeaders = ["X-DishUp-Key": "\(GlobalConstants.API.key)"]
    
    static func getDishTypes(requester: DishTypesVC, completion: (() -> ())? = nil){
        //
        Alamofire.request(.GET, "\(GlobalConstants.API.url)dish_types")
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)
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
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)
                    if let dishes = jsonObj["dishes"].arrayValue as [JSON]?{
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
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    print(json)
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)
                    if let dish = jsonObj["dish"] as JSON?{
                        let dishObj = Dish(json: dish)
                        requester.dish = dishObj
                        completion?()
                        
                    }
                }
        }
    }
    static func getRestaurants(requester: RestaurantsVC, location: CLLocation?, completion: (() -> ())? = nil){
        Alamofire.request(.GET, "\(GlobalConstants.API.url)restaurants")
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)

                    if let restaurants = jsonObj["restaurants"].arrayValue as [JSON]?{
                        
                        let restaurantsArray =  restaurants.map({ Restaurant(json: $0) })
                        requester.restaurantsArray = restaurantsArray
                        
                        completion?()
                    }
                }
        }

    }
    
    static func getImageAtUrl (imageURL : String, completion: ((UIImage) -> ())? = nil) {
        let allowedSet = NSCharacterSet(charactersInString:"=#%<>?@^{|}\"' ").invertedSet
        let escapedUrl = imageURL.stringByAddingPercentEncodingWithAllowedCharacters(allowedSet)!
        if let imageObj = imageCache[escapedUrl]{
            
            
            completion?(imageObj)
        }else{
            print("URL: \(escapedUrl)")
            Alamofire.request(.GET, escapedUrl).response() { (request, response, data, error) in
                    if error == nil{
                        
                        if let imageObj = UIImage(data: data!){
                            
                            imageCache[escapedUrl] = imageObj
                            completion?(imageObj)

                        }
                    
                }
            }
        }
    }
}
