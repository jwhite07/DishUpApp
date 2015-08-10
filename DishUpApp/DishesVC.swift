//
//  DishesVC.swift
//  DishUpApp
//
//  Created by James White on 7/20/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import pop

enum LayoutMode{
    case Single
    case Grid
}
var layoutMode  = LayoutMode.Single
var layoutButtonImg = UIImage(named: "grid-view.png")

class DishesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "dish"
    @IBOutlet weak var zoomLevel: UIButton!
    @IBOutlet weak var dishes: UICollectionView!
    var transitionLayout : UICollectionViewTransitionLayout?
    var dishType:DishType?
    var restaurant:Restaurant?
    
    var dishesArray : [Dish] = []
    let transition = NavigationFlipTransitionController()
    let singleLayout = DishesSingleLayout()
    let gridLayout = DishesGridLayout()
    
    
    
    @IBAction func switchToGridView(sender: AnyObject) {
        
            let visible = self.dishes.visibleCells() as! [DishCollectionViewCell]
            var toLayout : UICollectionViewLayout
            if layoutMode == .Single{
                layoutMode = .Grid
                layoutButtonImg = UIImage(named: "single-view.png")
                toLayout = gridLayout
            }else{
                layoutMode = .Single
                layoutButtonImg = UIImage(named: "grid-view.png")
                toLayout = singleLayout

            }
        let transition = self.dishes.startInteractiveTransitionToCollectionViewLayout(toLayout, completion: nil)
        
        let springAnimation = POPSpringAnimation()
        
        let property = POPAnimatableProperty.propertyWithName("transitionProgress", initializer:  {
            (prop) in
            prop.readBlock = {
                (obj, values) in
                values[0] = (obj as! UICollectionViewTransitionLayout).transitionProgress
            }
            prop.writeBlock = {
                (obj, values) in
                (obj as! UICollectionViewTransitionLayout).transitionProgress = values[0]
            }
            prop.threshold = 0.01
        }) as! POPAnimatableProperty
        
        
        
        springAnimation.springBounciness = 8
        springAnimation.property = property
        springAnimation.fromValue = CGFloat(0)
        springAnimation.toValue = 1.0
        springAnimation.completionBlock = {(anim: POPAnimation!, finished: Bool) in
            if finished {
                transition.transitionProgress = 1
                self.dishes.finishInteractiveTransition()
            }
            
        }
        self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
        
        for c  in visible {
            c.showForGrid()
        }

        transition.pop_addAnimation(springAnimation, forKey: NSStringFromSelector("transitionProgress"))

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //let gridLayout = dishes.
        
        
        print("Screen Width \(screenWidth)")
        print("Screen Height \(screenHeight)")
    
        if let dishTypeId = dishType?.id{
            Networking.getDishes(self, urlParent: "dish_types/\(dishTypeId)", completion: {self.dishes!.reloadData()})

        }else if let restaurantId = restaurant?.id{
            Networking.getDishes(self, urlParent: "restaurants/\(restaurantId)", completion: {self.dishes!.reloadData()})
            
        }else{
            Networking.getDishes(self, urlParent: nil, completion: {self.dishes!.reloadData()})
        }
        self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
      
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dishesArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dish : Dish
        let cellReuse : String
        dish = dishesArray[indexPath.row]

        
            cellReuse = "dishSingle"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishCollectionViewCell
        
               //print ("IndexPath.row: \(indexPath.row)")
        
               // cell.dishPic.image = UIImage(named: "placeholder.png")
                    cell.dishName.text = dish.name.uppercaseString
           // cell.dishDesc.text = dish.description
            
            if indexPath.row == 0{
                cell.leftArrow.hidden = true
                cell.hideLeftArrow = true
            }else{
                cell.leftArrow.hidden = false
            }
            if indexPath.row == dishesArray.count - 1{
                cell.rightArrow.hidden = true
                cell.hideRightArrow = true
            }else{
                cell.rightArrow.hidden = false
            }
        cell.dish = dish

        if dish.price != nil && dish.price != 0 {
            let price = dish.price!
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            // formatter.locale = NSLocale.currentLocale() // This is the default
             // "$123.44"

            cell.dishPrice.text = formatter.stringFromNumber(price)
        }else{
            cell.dishPrice.text = nil
        }
        cell.dishRating.rating = dish.rating.doubleValue
        if dish.lead_dishpic_url != nil{
            cell.dishPic.image = UIImage(named: "placeholder.png")
            

            Networking.getImageAtUrl(dish.lead_dishpic_url!, completion:
                {(imageObj: UIImage) in
                    cell.dishPic.image = imageObj
                    
            })
            let dishPicTap = UITapGestureRecognizer(target: self, action: Selector("dishPicTap:"))
            cell.dishPic.addGestureRecognizer(dishPicTap)
            cell.dishPic.userInteractionEnabled = true
            let i = tagCache.count * 2
            cell.tag = i + 1
            cell.dishPic.tag = i + 2
            tagCache[cell.dishPic.tag] = cell.tag
                        
           // cell.tag =
        }
        
//        cell.dragHandle.addGestureRecognizer(cell.dragHandleUp)
//        cell.dragHandle.addGestureRecognizer(cell.dragHandleDown)
//        cell.dragHandle.userInteractionEnabled = true
        cell.indexPath = indexPath
        cell.collectionView = dishes
        if layoutMode == .Grid{
            cell.hideForGrid()
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DishCollectionViewCell
        let dishDetailVC = segue.destinationViewController as! DishDetailVC
        dishDetailVC.dish = cell.dish
    }
    func dishPicTap( sender: AnyObject) {
        if let imageView = sender.view as! UIImageView?{
            print(imageView)
            print("ImageView Tag: \(imageView.tag) tagCache: \(tagCache) cellTag: \(tagCache[imageView.tag])")
            if let cell = dishes.viewWithTag(tagCache[imageView.tag]!) as! DishCollectionViewCell?{
                print(cell)
                performSegueWithIdentifier("showDishDetailSegue", sender: cell)
            }
            

        }
    }
    func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let layout =  DishesTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return layout
    }
   
    

    
}
