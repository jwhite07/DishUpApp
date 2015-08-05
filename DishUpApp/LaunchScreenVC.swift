//
//  LaunchScreenVC.swift
//  DishUpApp
//
//  Created by James White on 8/1/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class LaunchScreenVC: UIViewController {

    @IBAction func tapLocation(sender: AnyObject) {
        
    }
    @IBAction func tapCraving(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var cravingButton: UIView!
    @IBOutlet weak var locationButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cravingButton.layer.borderWidth = 1
        locationButton.layer.borderWidth = 1
        cravingButton.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
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

}
