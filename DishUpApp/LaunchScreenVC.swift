//
//  LaunchScreenVC.swift
//  DishUpApp
//
//  Created by James White on 8/1/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import CoreLocation
import Mixpanel
import AMPopTip



let onboarding = OnboardingController()
let locationManager = CLLocationManager()

class LaunchScreenVC: UIViewController {
    var promo : Promo?
    
   
    @IBOutlet weak var promoButton: PromoButtonView!
    @IBOutlet weak var promoLabel: UILabel!
    @IBOutlet weak var promoImage: UIImageView!

    

    @IBAction func tapPromoButton(sender: AnyObject) {
        switch promoButton.promo!.action{
        case "restaurant_link":
            performSegueWithIdentifier("promoToRestaurantDishes", sender: promoButton)
        case "dish_type_link":
            performSegueWithIdentifier("promoToDishTypeDishes", sender: promoButton)
        
        case "url_link":
            //performSegueWithIdentifier("promoToDishType", sender: promoButton)
            UIApplication.sharedApplication().openURL(NSURL(string: promoButton.promo!.url!)!)

            
        case "special_event_link":
            performSegueWithIdentifier("promoToRestaurant", sender: promoButton)

        default:
            print("invalid promo action")
        }
        
        
    }
    
    @IBAction func tapLocation(sender: AnyObject) {
        
    }
    @IBAction func tapCraving(sender: AnyObject) {
        
    }
    
    
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var cravingButton: UIView!
    @IBOutlet weak var locationButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
//        Networking.getSpecialEvents(self)
        
        onboarding.displayOnboardingPopTip(
            "Begin by selecting how you want to browse",
            direction: AMPopTipDirection.None,
            inView: self.view,
            fromFrame: self.view.frame,
            key: "LaunchScreenInfo",
            onDismiss: nil
        )

        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(animated: Bool) {
        Networking.getPromos(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            Mixpanel.sharedInstance().track("Segue From Launch Screen ", properties: [NSString(string: "Identifier") : id])
            if id == "promoToRestaurantDishes" {
                let navController = segue.destinationViewController as! UINavigationController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
//
                navController.pushViewController(dishesVC, animated: false)
                dishesVC.menuId = promoButton.promo!.menu_id
                    
                    
                
                    
            }
            if id == "promoToDishTypeDishes" {
                let navController = segue.destinationViewController as! UINavigationController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
                //
                navController.pushViewController(dishesVC, animated: false)
                dishesVC.dishTypeId = promoButton.promo?.dish_type_id

            }
            
            if id == "promoToRestaurants" {
                if let button = sender!.view as? PromoButtonView{
                    let restaurantsVC = (segue.destinationViewController as! UINavigationController).viewControllers.first as! RestaurantsVC
                    restaurantsVC.specialEventId = button.promo!.special_event_id
                    
                }
            }


        }
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
