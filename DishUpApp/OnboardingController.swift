//
//  OnboardingController.swift
//  DishUpApp
//
//  Created by James White on 8/17/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import AMPopTip

class OnboardingController {
    
    func displayOnboardingPopTip(text: String, direction: AMPopTipDirection, inView: UIView, fromFrame: CGRect, key: String){
        if shouldDisplay(key){
            print("from Frame: \(fromFrame)")
            let popTip = AMPopTip()
            popTip.delayIn = 1
            popTip.entranceAnimation = AMPopTipEntranceAnimation.Scale
            //popTip.arrowPosition = CGPointMake(0, 0)
            popTip.popoverColor = UIColor.whiteColor()
            popTip.font = UIFont(name: "SourceSansPro-Regular", size: 17.0)
            popTip.textColor = UIColor(red:1.00, green:0.46, blue:0.42, alpha:1.0)
            popTip.edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8)
            //popTip.shouldDismissOnTap = true

            popTip.showText(text, direction: direction, maxWidth: 200, inView: inView, fromFrame: fromFrame, duration: 5)
            //delay(5){popTip.hide()}
        }
    }
    func shouldDisplay(key: String) -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("onboardingLock"){
            if !defaults.boolForKey(key){
                defaults.setBool(true, forKey: key)
                return true
            }else{
                
                return false
            }
        }
        return true
    }
}
