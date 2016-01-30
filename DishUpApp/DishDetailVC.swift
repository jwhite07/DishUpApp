//
//  DishDetailVC.swift
//  DishUpApp
//
//  Created by James White on 7/31/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Cosmos
import Mixpanel


class DishDetailVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "dish"
    var dish:Dish?
    var restaurant:Restaurant?
    var website : String?
    var location : String?
    var phone : String?
    
    
    
    @IBOutlet weak var dishpics: UICollectionView!
    

    @IBOutlet weak var dishRating: CosmosView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishDesc: UITextView!
    
    @IBOutlet weak var restarauntName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantCityStZip: UILabel!

    @IBOutlet weak var restaurantLogo: UIImageView!
    
    
    @IBOutlet weak var largePic: UIImageView!
    
    @IBOutlet weak var callButton: UIView!
    @IBOutlet weak var mapButton: UIView!
    @IBOutlet weak var websiteButton: UIView!
    
    func mapTap(sender: AnyObject) {
        let allowedSet = NSCharacterSet(charactersInString:"=#%<>?@^{|}\"'").invertedSet
        let cleanLocation = location!.stringByReplacingOccurrencesOfString(" ", withString: "+").stringByAddingPercentEncodingWithAllowedCharacters(allowedSet)!
        let mapUrl = "http://maps.apple.com/?q=\(cleanLocation)"
        Analytics.trackEvent("Dish Detail Action Tap", properties:
            [
                "Button" : "Map",
                "Restaurant" : restarauntName.text!,
                "Dish"      : dishName.text!
            ])
        UIApplication.sharedApplication().openURL(NSURL(string: mapUrl)!)
    }
    
    func websiteTap(sender: AnyObject) {
        Analytics.trackEvent("Dish Detail Action Tap", properties:
            [
                "Button" : "Website",
                "Restaurant" : restarauntName.text!,
                "Dish"      : dishName.text!
            ])
        UIApplication.sharedApplication().openURL(NSURL(string: website!)!)
    }
    func callTap(sender: AnyObject) {
        if phone != nil && phone != ""{
            let phoneStripped = phone!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let sep = ""
            
            let phoneUrl = NSURL(string: "tel://\(phoneStripped.joinWithSeparator(sep))")
            Analytics.trackEvent("Dish Detail Action Tap", properties:
                [
                    "Button" : "Phone",
                    "Restaurant" : restarauntName.text!,
                    "Dish"      : dishName.text!
                ])
            UIApplication.sharedApplication().openURL(phoneUrl!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.viewScreen("Dish Info")
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let dishSafe = self.dish{
            updateSubViews(dishSafe)
            Networking.getDishDetails(self, dishId: dishSafe.id, location: restaurant, completion: {
                self.dishpics.reloadData()
                self.updateSubViews(self.dish!)
            })
        }
        let mapTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("mapTap:"))
        let callTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("callTap:"))
        let websiteTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("websiteTap:"))
        
        self.mapButton.addGestureRecognizer(mapTapRecognizer)
        self.callButton.addGestureRecognizer(callTapRecognizer)
        self.websiteButton.addGestureRecognizer(websiteTapRecognizer)

        
    }
   
    func updateSubViews(dish: Dish) {
        self.dishRating.rating      = dish.rating.doubleValue
        self.dishName.text          = dish.name.uppercaseString
        if let url = Networking.sanitizeUrlFromString(dish.lead_dishpic_url){
            self.largePic.sd_setImageWithURL(url)
            
        }

        
        if dish.price != nil && dish.price != 0 {
            let price = dish.price!
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            
            self.dishPrice.text = formatter.stringFromNumber(price)
        }else{
            self.dishPrice.text = nil
        }

        self.dishDesc.text          = dish.description
        self.dishDesc.scrollRangeToVisible(NSMakeRange(0, 1))
        
        self.restarauntName.text    = dish.restaurant?.name.uppercaseString
        self.restaurantAddress.text = dish.restaurant?.address
        if let rest = dish.restaurant{
            var postal_code = ""
            if let zip = rest.postal_code{
                 postal_code = zip
                
            }
            self.restaurantCityStZip.text = "\(rest.city), \(rest.state) \(postal_code)"
            location = "\(rest.name) \(rest.address) \(rest.city) \(rest.state) \(postal_code)"
            
            
        }
        if let url = Networking.sanitizeUrlFromString(dish.restaurant?.logo){
            self.restaurantLogo.sd_setImageWithURL(url)
        }

        
        website = dish.restaurant?.website
        phone = dish.restaurant?.phone_number
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dish!.dishpics.count
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = self.dishpics.frame.size.height
        let width = height / 16 * 9
        return CGSizeMake(width, height)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dishpic : Dishpic
        let cellReuse = "dishpic"
        dishpic = dish!.dishpics[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishpicCell
        
        print ("IndexPath.row: \(indexPath.section)")
        if let url = Networking.sanitizeUrlFromString(dishpic.url){
            cell.imageView.sd_setImageWithURL(url)
            
        }
        cell.dish = self.dish
        
        cell.dishpic = dishpic
        cell.indexPath = indexPath
        
        
        return cell
    }
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = dishpics.cellForItemAtIndexPath(indexPath)
//        let rect = CGRectMake(cell!.bounds.origin.x+10, cell!.bounds.origin.y+10, 50, 30)
//        UIPopoverController().presentPopoverFromRect(rect, inView: cell!, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
//    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DishpicCell
        let dishpicVC = segue.destinationViewController as! DishPicsVC
        dishpicVC.dish = cell.dish
        dishpicVC.startIndex = cell.indexPath
        
    }



}
