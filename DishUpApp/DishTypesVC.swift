//
//  DishTypesVC.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import AMPopTip
import SDWebImage
import Mixpanel

class DishTypesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    let reuseIdentifier = "dish_type"
        var dishTypesArray : [DishType] = []
    let popTip = AMPopTip()
//     let transition = NavigationFlipTransitionController()
    
    
    //@IBOutlet var dishTypes: UICollectionView?
    
    @IBOutlet weak var dishTypes: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
  
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.viewScreen("Cravings Listing")
        
    }
    override func viewDidLoad() {
        popTip.popoverColor = UIColor.whiteColor()
        popTip.font = UIFont(name: "SourceSansPro-Regular", size: 17.0)
        popTip.textColor = UIColor(red:1.00, green:0.46, blue:0.42, alpha:1.0)
        popTip.edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8)

        Networking.getDishTypes(self, completion: {
            self.dishTypes!.reloadData()
            onboarding.displayOnboardingPopTip(
                "Choose the food you're craving. Press and hold any icon to see its name.",
                direction: AMPopTipDirection.None,
                inView: self.view,
                fromFrame: self.view.frame,
                key: "DishTypesIntro",
                onDismiss: nil
            )

        })
        
        if self.revealViewController() != nil {
            
            menuButton.targetForAction("revealToggle:", withSender: nil)
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//        navigationController?.delegate = self
            }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishTypesArray.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(23, 23, 23, 23)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dish_type", forIndexPath: indexPath) as! DishTypeCollectionViewCell
        
        print(dishTypesArray[indexPath.row])
        if let icon_url = dishTypesArray[indexPath.row].icon_url{
            if let url = Networking.sanitizeUrlFromString(icon_url){
                cell.imageView.sd_setImageWithURL(url)
                
            }
        }
        cell.dishType = dishTypesArray[indexPath.row]
        let longTap = UILongPressGestureRecognizer(target: self, action: Selector("showToolTip:"))
        cell.addGestureRecognizer(longTap)
        
        cell.userInteractionEnabled = true
        
        //cell.label.text = dishTypesArray[indexPath.row].name
        cell.indexPath = indexPath
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            var props : [String : String] = [:]
            if id == "dishTypeToDishSegue" {
                let cell = sender as! DishTypeCollectionViewCell
                let dishesVC = segue.destinationViewController as! DishesVC
                dishesVC.dishType = cell.dishType
                props["Craving"] = cell.dishType?.name
                
                
                
            }
            props["Identifier"] = id
            Analytics.trackEvent("Segue From Craving Screen ", properties: props)
        }
    }
    func showToolTip( sender: AnyObject) {
        
        
        
    
        if sender.state == UIGestureRecognizerState.Began{
            
            let cell = sender.view as! DishTypeCollectionViewCell
            let relativeX = cell.frame.origin.x - self.dishTypes.contentOffset.x
            let relativeY = cell.frame.origin.y - self.dishTypes.contentOffset.y
            
            var direction : AMPopTipDirection = .Up
            
            if relativeY <= 30{
                direction = .Right
               
                if relativeX >= screenWidth - 100{
                    direction = .Left
                }
            }
            
            let relativeFrame = CGRectMake(relativeX, relativeY, cell.frame.width, cell.frame.height)
            popTip.showText(cell.dishType!.name.uppercaseString, direction: direction , maxWidth: 200, inView: self.view, fromFrame: relativeFrame)
        }else if sender.state == UIGestureRecognizerState.Ended {
            popTip.hide()
        }
        
    }
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.reverse = operation == .Pop
//        return transition
//    }
    
}
