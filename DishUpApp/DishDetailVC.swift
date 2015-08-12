//
//  DishDetailVC.swift
//  DishUpApp
//
//  Created by James White on 7/31/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Cosmos


class DishDetailVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "dish"
    var dish:Dish?
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

    
    @IBOutlet weak var largePic: UIImageView!
    
    @IBAction func mapTap(sender: AnyObject) {
        let allowedSet = NSCharacterSet(charactersInString:"=#%<>?@^{|}\"'").invertedSet
        
        
        let cleanLocation = location!.stringByReplacingOccurrencesOfString(" ", withString: "+").stringByAddingPercentEncodingWithAllowedCharacters(allowedSet)!
       

        
        let mapUrl = "http://maps.apple.com/?q=\(cleanLocation)"
        UIApplication.sharedApplication().openURL(NSURL(string: mapUrl)!)
    }
    
    @IBAction func websiteTap(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: website!)!)
    }
    @IBAction func callTap(sender: AnyObject) {
        let phoneStripped = "".join(phone!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        let phoneUrl = NSURL(string: "tel://\(phoneStripped)")
        UIApplication.sharedApplication().openURL(phoneUrl!)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let dishSafe = self.dish{
            updateSubViews(dishSafe)
            Networking.getDishDetails(self, dishId: dishSafe.id, completion: {
                self.dishpics.reloadData()
                self.updateSubViews(self.dish!)
            })
        }
    }
   
    func updateSubViews(dish: Dish) {
        self.dishRating.rating      = dish.rating.doubleValue
        self.dishName.text          = dish.name
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
        
        self.restarauntName.text    = dish.restaurant?.name
        self.restaurantAddress.text = dish.restaurant?.address
        if let rest = dish.restaurant{
            var postal_code = ""
            if let zip = rest.postal_code{
                 postal_code = zip
                
            }
            self.restaurantCityStZip.text = "\(rest.city), \(rest.state) \(postal_code)"
            location = "\(rest.name) \(rest.address) \(rest.city) \(rest.state) \(postal_code)"
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
        return CGSizeMake(135, 240)
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

        
        cell.dishpic = dishpic

        
        
        return cell
    }


}
