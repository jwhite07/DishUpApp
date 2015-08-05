//
//  DishTypesVC.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit

class DishTypesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    let reuseIdentifier = "dish_type"
        var dishTypesArray : [DishType] = []

    //@IBOutlet var dishTypes: UICollectionView?
    
    @IBOutlet weak var dishTypes: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
  
    
    override func viewDidLoad() {
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
        //cell.label.text = dishTypesArray[indexPath.row].name
        
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DishTypeCollectionViewCell
        let dishesVC = segue.destinationViewController as! DishesVC
        dishesVC.dishType = cell.dishType
    }
}
