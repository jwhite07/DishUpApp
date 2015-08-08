//
//  DishTypesVC.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import AMPopTip

class DishTypesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    let reuseIdentifier = "dish_type"
        var dishTypesArray : [DishType] = []
    let popTip = AMPopTip()
    
    
    //@IBOutlet var dishTypes: UICollectionView?
    
    @IBOutlet weak var dishTypes: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
  
    
    @IBOutlet weak var toolTip: UIView!
    
    @IBOutlet weak var toolTipLabel: UILabel!
    
    override func viewDidLoad() {
        popTip.popoverColor = UIColor.whiteColor()
        popTip.font = UIFont(name: "SourceSansPro-Regular", size: 17.0)
        popTip.textColor = UIColor(red:1.00, green:0.46, blue:0.42, alpha:1.0)
        popTip.edgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        

        Networking.getDishTypes(self, completion: {self.dishTypes!.reloadData()})
        
        if self.revealViewController() != nil {
            
            menuButton.targetForAction("revealToggle:", withSender: nil)
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishTypesArray.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(30, 30, 30, 30)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dish_type", forIndexPath: indexPath) as! DishTypeCollectionViewCell
        
        print(dishTypesArray[indexPath.row])
        let icon_url = dishTypesArray[indexPath.row].icon_url
        if icon_url != nil{
            cell.imageView.image = UIImage(named: "placeholder.png")
            cell.imageView.tintColor = UIColor.redColor()
            
            Networking.getImageAtUrl(icon_url!, completion: {(imageObj: UIImage) in cell.imageView.image = imageObj})
        }
        cell.dishType = dishTypesArray[indexPath.row]
        let longTap = UILongPressGestureRecognizer(target: self, action: Selector("showToolTip:"))
        cell.addGestureRecognizer(longTap)
        
        cell.userInteractionEnabled = true
        
        //cell.label.text = dishTypesArray[indexPath.row].name
        
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dishTypeToDishSegue" {
            let cell = sender as! DishTypeCollectionViewCell
            let dishesVC = segue.destinationViewController as! DishesVC
            dishesVC.dishType = cell.dishType

        }
        
    }
    func showToolTip( sender: AnyObject) {
        if sender.state == UIGestureRecognizerState.Began{
            print("Color: \(popTip.backgroundColor) Font: \(popTip.font) Text color: \(popTip.textColor)")
            let cell = sender.view as! DishTypeCollectionViewCell
            popTip.showText(cell.dishType!.name.uppercaseString, direction: AMPopTipDirection.Up , maxWidth: 200, inView: self.dishTypes!, fromFrame: cell.frame)
        }else if sender.state == UIGestureRecognizerState.Ended {
            popTip.hide()
        }
        
    }

}
