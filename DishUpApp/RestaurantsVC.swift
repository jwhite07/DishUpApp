//
//  RestaurantsVC.swift
//  DishUpApp
//
//  Created by James White on 7/30/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import CoreLocation
import Mixpanel
import AMPopTip

class RestaurantsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchResultsUpdating {
    let reuseIdentifier = "restaurant"
    var restaurantsArray : [Restaurant] = []
    var restaurantsFullArray : [Restaurant] = []
    var searchController: UISearchController!
    
    @IBOutlet weak var searchContainer: UIView!
//    let transition = NavigationFlipTransitionController()
    var specialEvent : SpecialEvent?
    var specialEventId : Int?



    @IBOutlet weak var restaurants: UICollectionView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.viewScreen("Restaurants Listing")
        
    }
    override func viewDidLoad() {
        
        let location = locationManager.location
        var urlParent : String?
        
        if specialEventId != nil{
            urlParent = "special_events/\(specialEventId!)"
        }else{
            
        }
        
        Networking.getRestaurants(self, urlParent: urlParent, location: location, completion: {
            self.restaurantsArray = self.restaurantsFullArray
            self.restaurants!.reloadData()
            
            onboarding.displayOnboardingPopTip(
                "Choose a restaurant to see their menu",
                direction: AMPopTipDirection.None,
                inView: self.view,
                fromFrame: self.view.frame,
                key: "ChooseARestaurant",
                onDismiss: nil
            )

        })
        
        if self.revealViewController() != nil {
            
            //menuButton.targetForAction("revealToggle:", withSender: nil)
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
//        navigationController?.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        restaurantsArray = searchText.isEmpty ? restaurantsFullArray : restaurantsFullArray.filter(){
//            if let name = ($0 as Restaurant).name as String! {
//                print("searchText: \(searchText) name: \(name) range: \(name.rangeOfString(searchText))")
//                return name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
//            }else{
//                return false
//            }
//        }
//        
//        restaurants.reloadData()
//    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        restaurantsArray = searchText!.isEmpty ? restaurantsFullArray : restaurantsFullArray.filter({(restaurant: Restaurant) -> Bool in
            return restaurant.name.rangeOfString(searchText!, options: .CaseInsensitiveSearch) != nil
        })
        restaurants.reloadData()
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
        if let url = Networking.sanitizeUrlFromString(cell.restaurant?.logo){
            cell.restaurantImg.sd_setImageWithURL(url)
            cell.backgroundImage.sd_setImageWithURL(url)
            
        }
        
        if let distance = cell.restaurant?.distance{
            let distanceTrimmed = String(format: "%.1f", distance)
            cell.restaurantDistance.text = "\(distanceTrimmed) mi"
        }else{
            cell.restaurantDistance.text = ""
        }
        cell.restaurant = restaurantsArray[indexPath.row]
        cell.restaurantName.text = cell.restaurant!.name
        cell.restaurantCitySt.text = "\(cell.restaurant!.city), \(cell.restaurant!.state)"
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
               
        if let id = segue.identifier{
            var props : [String : String] = [:]
            if id == "restaurantToDishesSegue" {
                let cell = sender as! RestaurantCell
                let dishesVC = segue.destinationViewController as! DishesVC
                dishesVC.restaurant = cell.restaurant
                props["Restaurant"] = cell.restaurant?.name
                
                
                
                
            }
            props["Identifier"] = id
            Analytics.trackEvent("Segue From Restaurant Screen ", properties: props)
        }

    }
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let collectionWidth = restaurants.bounds.size.width
            let collectionHeight = restaurants.bounds.size.height
            
            var cellWidth : CGFloat
    
            var cellHeight : CGFloat
            
                 cellWidth = collectionWidth
                 cellHeight = cellWidth / 16 * 9
            print("collection x: \(collectionWidth) y: \(collectionHeight) cell x: \(cellWidth) y: \(cellHeight)")
            return CGSizeMake(cellWidth, cellHeight)
        }
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.reverse = operation == .Pop
//        return transition
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
