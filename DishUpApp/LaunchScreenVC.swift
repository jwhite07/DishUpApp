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
    var specialEvent : SpecialEvent?
    @IBOutlet weak var specialEventButton: SpecialEventButtonView?
   
    @IBAction func specialEventTap(sender: AnyObject) {
        
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
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        Networking.getSpecialEvents(self)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            Mixpanel.sharedInstance().track("Segue From Launch Screen ", properties: [NSString(string: "Identifier") : id])
            if id == "specialEventSegue" {
                if let button = sender!.view as? SpecialEventButtonView{
                    let restaurantsVC = (segue.destinationViewController as! UINavigationController).viewControllers.first as! RestaurantsVC
                    restaurantsVC.specialEvent = button.specialEvent
                    
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
