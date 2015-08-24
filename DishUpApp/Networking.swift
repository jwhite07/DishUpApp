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
import SDWebImage


class Networking {
    static var params : [String:String] = [:]
    static func setParams(){
        params["latitude"] = locationManager.location?.coordinate.latitude.description
        params["longitude"] = locationManager.location?.coordinate.longitude.description
        print("params: \(params)")
    }
    
    // static let manager = Manager.sharedInstance
    // Add API key header to all requests make with this manager (i.e., the whole session)
    
    // manager.session.configuration.HTTPAdditionalHeaders = ["X-DishUp-Key": "\(GlobalConstants.API.key)"]
    
    static func getDishTypes(requester: DishTypesVC, completion: (() -> ())? = nil){
        //
        Alamofire.request(.GET, "\(GlobalConstants.API.url)dish_types", parameters: params)
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    let jsonData = json.value
                    print("dish type json: \(json.value)")
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
        setParams()
        var requestUrl : String
        requestUrl = GlobalConstants.API.url
        
        if let u = urlParent{
            requestUrl += u
        }
        requestUrl += "/dishes"
        print("Dishes Request url: \(requestUrl)")
        Alamofire.request(.GET, requestUrl, parameters: params)
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    print("dish json: \(json.value)")
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)
                    if let dishes = jsonObj["dish_previews"].arrayValue as [JSON]?{
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
        setParams()
       
        Alamofire.request(.GET, requestUrl, parameters: params)
            .responseJSON {(request, response, json)in
                print("dish details json: \(json.value)")
                if json.isSuccess{
                    
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
        setParams()
        
        Alamofire.request(.GET, "\(GlobalConstants.API.url)locations", parameters: params)
            .responseJSON {(request, response, json)in
                print("get restaurantsjson: \(json.value)")
                if json.isSuccess{
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)

                    if let restaurants = jsonObj["locations"].arrayValue as [JSON]?{
                        
                        let restaurantsArray =  restaurants.map({ Restaurant(json: $0) })
                        requester.restaurantsArray = restaurantsArray
                        
                        completion?()
                    }
                }
        }

    }
    static func sanitizeUrlFromString(string: String?) -> NSURL?{
        if let url = string{
            let allowedSet = NSCharacterSet(charactersInString:"=#%<>?@^{|}\"' ").invertedSet
            let escapedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(allowedSet)!
            return NSURL(string: escapedUrl)

        }else{
            return nil
        }
        
        
    }
//    static func getImageAtUrl (imageURL : String, completion: ((UIImage) -> ())? = nil) {
//        let allowedSet = NSCharacterSet(charactersInString:"=#%<>?@^{|}\"' ").invertedSet
//        let escapedUrl = imageURL.stringByAddingPercentEncodingWithAllowedCharacters(allowedSet)!
//        
//        let manager = SDWebImageManager.sharedManager()
//        
////        if let imageObj = imageCache.objectForKey(escapedUrl) as! UIImage?{
////            
////            
////            completion?(imageObj)
////        }else{
////            print("URL: \(escapedUrl)")
////            Alamofire.request(.GET, escapedUrl).response() { (request, response, data, error) in
////                    if error == nil{
////                        
////                        if let imageObj = UIImage(data: data!){
////                            
////                            imageCache.setObject(imageObj, forKey: escapedUrl)
////                            completion?(imageObj)
////
////                        }
////                    
////                }
////            }
////        }
//    }
}
