//
//  RestaurantsVC.swift
//  DishUpApp
//
//  Created by James White on 7/30/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class RestaurantsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "restaurant"
    var restaurantsArray : [Restaurant] = []


    @IBOutlet weak var restaurants: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.getRestaurants(self, completion: {self.restaurants!.reloadData()})

        if self.revealViewController() != nil {
            
            //menuButton.targetForAction("revealToggle:", withSender: nil)
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("restaurant", forIndexPath: indexPath) as! RestaurantCell
        
        cell.restaurant = restaurantsArray[indexPath.row]
        if let logo_url = cell.restaurant?.logo{
            cell.restaurantImg.image = UIImage(named: "placeholder.png")
            
            Networking.getImageAtUrl(logo_url, completion: {(imageObj: UIImage) in cell.restaurantImg.image = imageObj})
        }
        cell.restaurant = restaurantsArray[indexPath.row]
        cell.restaurantName.text = cell.restaurant!.name
        cell.restaurantCitySt.text = "\(cell.restaurant!.city), \(cell.restaurant!.state)"
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! RestaurantCell
        let dishesVC = segue.destinationViewController as! DishesVC
        dishesVC.restaurant = cell.restaurant
    }
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let collectionWidth = restaurants.bounds.size.width
            let collectionHeight = restaurants.bounds.size.height
            
            var cellWidth : CGFloat
    
            var cellHeight : CGFloat
            
                 cellWidth = collectionWidth
                 cellHeight = collectionHeight / 3
            
            return CGSizeMake(cellWidth, cellHeight)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
