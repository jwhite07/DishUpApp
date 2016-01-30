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
    static var loaded = false
    static var params : [String:String] = [:]
    static func setParams(){
        params["latitude"] = locationManager.location?.coordinate.latitude.description
        params["longitude"] = locationManager.location?.coordinate.longitude.description
        print("locationManager: \(locationManager), location: \(locationManager.location), coordinates: \(locationManager.location?.coordinate)")
        print("params: \(params)")
    }
    
    // static let manager = Manager.sharedInstance
    // Add API key header to all requests make with this manager (i.e., the whole session)
    
    // manager.session.configuration.HTTPAdditionalHeaders = ["X-DishUp-Key": "\(GlobalConstants.API.key)"]
    
    static func getDishTypes(requester: DishTypesVC, completion: (() -> ())? = nil){
        //
        LoadingOverlay.shared.showOverlay(requester.view)
        Alamofire.request(.GET, "\(GlobalConstants.API.url)dish_types", parameters: params)
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    let jsonData = json.value
                   // print("dish type json: \(json.value)")
                    var jsonObj = JSON(jsonData!)
                    if let dishtypes = jsonObj["dish_types"].arrayValue as [JSON]?{
                        
                        let dishTypesArray =  dishtypes.map({ DishType(json: $0) })
                        requester.dishTypesArray = dishTypesArray

                        completion?()
                        LoadingOverlay.shared.hideOverlayView()
                    }
                }
        }

    }
//    static func getSpecialEvents(requester: LaunchScreenVC, completion: (() -> ())? = nil){
//        //
//        
//        Alamofire.request(.GET, "\(GlobalConstants.API.url)special_events", parameters: params)
//            .responseJSON {(request, response, json)in
//                if json.isSuccess{
//                    let jsonData = json.value
//                    print("dish type json: \(json.value)")
//                    var jsonObj = JSON(jsonData!)
//                    if let specialevents = jsonObj["special_events"].arrayValue as [JSON]?{
//                        
//                        let specialEvent =  SpecialEvent(json: specialevents[0])
//                        print(specialevents)
//                        if specialevents.count > 0{
//                            requester.specialEvent = specialEvent
//                            requester.specialEventButton!.hidden = false
//                            //requester.specialEventButton!.setTitle(specialEvent.name, forState: UIControlState.Normal)
//                            requester.promoImage.sd_setImageWithURL(promo.img, placeholderImage: UIImage(named: "placeholder.png"))
//
//                            requester.specialEventButton?.specialEvent = specialEvent
//                        }
//                        
//                        completion?()
//                    }
//                }
//        }
//        
//    }
    static func getPromos(requester: LaunchScreenVC, completion: (() -> ())? = nil){
        //
        print("starting promo fetch")
        setParams()
        
        Alamofire.request(.GET, "\(GlobalConstants.API.url)promos", parameters: params)
            .responseJSON {(request, response, json)in
               // print("json object: \(json), request: \(request), response: \(response)")
                if json.isSuccess{
                    let jsonData = json.value
                    //print("dish type json: \(json.value)")
                    var jsonObj = JSON(jsonData!)
                    if let promoJson = jsonObj["promo"] as JSON?{
                        
                         let promo =  Promo(json: promoJson)
                        
                            requester.promo = promo
                            requester.promoButton!.hidden = false
                            requester.promoLabel.text = promo.message
                            requester.promoLabel.backgroundColor = hexStringToUIColor(promo.title_color)
                            requester.promoButton.backgroundColor = hexStringToUIColor(promo.body_color)
                            requester.promoButton.promo = promo
                            if let promoimg = promo.img{
                                if let url = Networking.sanitizeUrlFromString(promoimg){
                                    requester.promoImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder.png"))
                                }
                                
                            }

                        
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
        
        if let dishId = requester.initialDishId{
            params["initialDishId"] = String(dishId)
        }
       // print("Dishes Request url: \(requestUrl)")
       // LoadingOverlay.shared.showOverlay(requester.view)
        Alamofire.request(.GET, requestUrl, parameters: params)
            .responseJSON {(request, response, json)in
                if json.isSuccess{
                    //print("dish json: \(json.value)")
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)
                    if let dishes = jsonObj["dish_previews"].arrayValue as [JSON]?{
                        let dishesArray = dishes.map({Dish(json: $0)})
                        requester.dishesFullArray = dishesArray
                        completion?()
                        //LoadingOverlay.shared.hideOverlayView()
                    }
                }
        }
        
    }

    static func getDishDetails(requester: DishDetailVC, dishId: Int, location: Restaurant?, completion: (() -> ())? = nil){
        var requestUrl : String
        requestUrl = "\(GlobalConstants.API.url)dishes/\(dishId)"
        setParams()
        if let loc = location{
            params["location_id"] = loc.id.description
        }
      // LoadingOverlay.shared.showOverlay(requester.view)
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
//                        LoadingOverlay.shared.hideOverlayView()
                    }
                }
        }
    }
    static func getRestaurants(requester: RestaurantsVC, urlParent: String?, location: CLLocation?, completion: (() -> ())? = nil){
        setParams()
        LoadingOverlay.shared.showOverlay(requester.view)
        var requestUrl : String
        requestUrl = GlobalConstants.API.url
        
        if let u = urlParent{
            requestUrl += "\(u)/"
        }
        requestUrl += "locations"
        print("Request URL: \(requestUrl)")
        
        Alamofire.request(.GET, requestUrl, parameters: params)
            .responseJSON {(request, response, json)in
                
                print("get restaurantsjson: \(json.value)")
                if json.isSuccess{
                    let jsonData = json.value
                    
                    var jsonObj = JSON(jsonData!)

                    if let restaurants = jsonObj["locations"].arrayValue as [JSON]?{
                        
                        let restaurantsArray =  restaurants.map({ Restaurant(json: $0) })
                        requester.restaurantsFullArray = restaurantsArray
                        
                        completion?()
                        LoadingOverlay.shared.hideOverlayView()
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
    static func hexStringToUIColor (color:String?) -> UIColor {
        if let hex = color{
            var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
            
            if (cString.hasPrefix("#")) {
                cString = String(cString.characters.dropFirst())
            }
            
            if (cString.characters.count != 6) {
                return  UIColor(red: 200, green: 200, blue: 200, alpha: 0.6)
                
                
            }
            
            var rgbValue:UInt32 = 0
            NSScanner(string: cString).scanHexInt(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(0.6)
            )

        }else{
            return  UIColor(red: 200, green: 200, blue: 200, alpha: 0)
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
