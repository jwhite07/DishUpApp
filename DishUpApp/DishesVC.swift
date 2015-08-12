//
//  DishesVC.swift
//  DishUpApp
//
//  Created by James White on 7/20/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import pop
import Cosmos

enum LayoutMode{
    case Single
    case Grid
}
var layoutMode  = LayoutMode.Single
var layoutButtonImg = UIImage(named: "grid-view.png")

class DishesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    let reuseIdentifier = "dish"
    @IBOutlet weak var zoomLevel: UIButton!
    @IBOutlet weak var dishes: UICollectionView!
    var transitionLayout : UICollectionViewTransitionLayout?
    var transitionInProgress = false
    var dishType:DishType?
    var restaurant:Restaurant?
    
    var dishesArray : [Dish] = []
    let transition = NavigationFlipTransitionController()
    let singleLayout = DishesSingleLayout()
    let gridLayout = DishesGridLayout()
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    var screenWidth : CGFloat = 0.0
    var screenHeight : CGFloat = 0.0
    
    var lastContentOffset : CGFloat = 0
    var currentDish : Dish?
    var nextDish : Dish?
    var hideLeftArrowNext = false
    var hideRightArrowNext = false
    var hideLeftArrowCurrent = false
    var hideRightArrowCurrent = false
    
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    @IBOutlet weak var currentDishName: UILabel!
    @IBOutlet weak var currentDishPrice: UILabel!
    @IBOutlet weak var currentDishRating: CosmosView!
    
    @IBOutlet weak var nextDishName: UILabel!
    @IBOutlet weak var nextDishRating: CosmosView!
    @IBOutlet weak var nextDishPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        if layoutMode == .Single{
            dishes.setCollectionViewLayout(singleLayout, animated: false)
        }else{
            dishes.setCollectionViewLayout(gridLayout, animated: false)
        }
        let loadComplete : () -> () = {
            
            self.dishes!.reloadData()
            if layoutMode == .Single{
                self.infoPanel.hidden = false
                self.leftArrow.hidden = false
                self.rightArrow.hidden = false
                self.setCurrentDish()
                if let current = self.currentDish{
                    self.updateDishInfo(current)
                }

            }else{
                self.infoPanel.hidden = true
                self.leftArrow.hidden = true
                self.rightArrow.hidden = true
            }
            
        }
        
        if let dishTypeId = dishType?.id{
            Networking.getDishes(self, urlParent: "dish_types/\(dishTypeId)", completion: loadComplete)
        }else if let restaurantId = restaurant?.id{
            Networking.getDishes(self, urlParent: "restaurants/\(restaurantId)", completion: loadComplete)
        }else{
            Networking.getDishes(self, urlParent: nil, completion: loadComplete)
        }
        self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
        lastContentOffset = dishes.contentOffset.x
        
        
    }
    
    func setCurrentDish(){
        if layoutMode == .Single{
            let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
            if let indexPath = dishes.indexPathForItemAtPoint(point){
                currentDish = dishesArray[indexPath.row]
                if indexPath.row == 0{
                    leftArrow.alpha = 0
                    hideLeftArrowCurrent = true
                }else{
                    hideLeftArrowCurrent = false
                }
                if indexPath.row == dishesArray.count - 1{
                    rightArrow.alpha = 0
                    hideRightArrowCurrent = true
                }else{
                    hideRightArrowCurrent = false
                }

            }
        }

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
        let cellReuse : String = "dishSingle"
        dish = dishesArray[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishCollectionViewCell
        
        cell.dish = dish
        if let url = Networking.sanitizeUrlFromString(dish.lead_dishpic_url!){
            cell.dishPic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder.png"))
            
        }

        
        cell.indexPath = indexPath
        cell.collectionView = dishes
        
        return cell
    }
    func updateDishInfo(dish: Dish){
        self.currentDishName.text = dish.name.uppercaseString
        self.currentDishRating.rating = dish.rating.doubleValue
        if dish.price != nil && dish.price != 0 {
            let price = dish.price!
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            self.currentDishPrice.text = formatter.stringFromNumber(price)
        }else{
            self.currentDishPrice.text = nil
        }
        currentDishName.alpha = 1
        currentDishPrice.alpha = 1
        currentDishRating.alpha = 1
        nextDishName.alpha = 0
        nextDishPrice.alpha = 0
        nextDishRating.alpha = 0

    }
    func updateNextDish(dish: Dish){
        self.nextDishName.text = dish.name.uppercaseString
        self.nextDishRating.rating = dish.rating.doubleValue
        if dish.price != nil && dish.price != 0 {
            let price = dish.price!
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            self.nextDishPrice.text = formatter.stringFromNumber(price)
        }else{
            self.nextDishPrice.text = nil
        }

    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if layoutMode == .Single{
            var point : CGPoint = CGPointMake(0,0)
            var destOffset : CGFloat = 0
            if self.lastContentOffset < scrollView.contentOffset.x{
                point = CGPointMake(dishes.frame.width + scrollView.contentOffset.x - 1, dishes.frame.height / 2 )
                destOffset = self.lastContentOffset + screenWidth
            }else if self.lastContentOffset > scrollView.contentOffset.x{
                point = CGPointMake(scrollView.contentOffset.x + 1, dishes.frame.height / 2 )
                destOffset = self.lastContentOffset - screenWidth
                
            }
            let percentage = (scrollView.contentOffset.x - self.lastContentOffset) / (destOffset - self.lastContentOffset)
            print("scrollViewOffset: \(scrollView.contentOffset.x) lastOffset: \(self.lastContentOffset) destOffset: \(destOffset) percentage: \(percentage)")

            let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point)!
            if nextDish == nil{
                nextDish = dishesArray[indexPath.row]
                updateNextDish(nextDish!)
                
            }else if nextDish!.name != dishesArray[indexPath.row].name{
                nextDish = dishesArray[indexPath.row]
                updateNextDish(nextDish!)
            }
            if indexPath.row == 0{
                hideLeftArrowNext = true
            }else{
                hideLeftArrowNext = false
            }
            if indexPath.row == dishesArray.count - 1{
                hideRightArrowNext = true
            }else{
                hideRightArrowNext = false
            }
            scrollViewDidScrolltoPercentageOffset(percentage)
            print("offset: \(scrollView.contentOffset.x) ")
            print("current Dish: \(currentDish?.name) next Dish: \(nextDish?.name)")
        }
        
        
    }
    
    func scrollViewDidScrolltoPercentageOffset(perc: CGFloat){
        let inv = 1 - perc
        currentDishName.alpha = inv
        currentDishPrice.alpha = inv
        currentDishRating.alpha = inv
        nextDishName.alpha = perc
        nextDishPrice.alpha = perc
        nextDishRating.alpha = perc
        
        
        if hideRightArrowNext == true{
            rightArrow.alpha = inv
        }else if (hideRightArrowCurrent == true && hideRightArrowNext == false){
            rightArrow.alpha = perc
        }
        if hideLeftArrowNext == true{
            leftArrow.alpha = inv
        }else if (hideLeftArrowCurrent == true && hideLeftArrowNext == false){
            leftArrow.alpha = perc
        }
        
        
        
    }
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if layoutMode == .Single{
            self.lastContentOffset = dishes.contentOffset.x
            setCurrentDish()
            updateDishInfo(currentDish!)
            

        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if layoutMode == .Single{
            if !decelerate{
                self.lastContentOffset = dishes.contentOffset.x
                setCurrentDish()
                updateDishInfo(currentDish!)
            }
 
        }
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if layoutMode == .Single{
            self.lastContentOffset = dishes.contentOffset.x
            setCurrentDish()
            updateDishInfo(currentDish!)

        }
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
   
    @IBAction func tapLeftArrow(sender: AnyObject) {
        let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
        let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point)!
        self.dishes!.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row - 1, inSection: indexPath.section),
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: true)
        
    }
    @IBAction func tapRightArrow(sender: AnyObject) {
        let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
        let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point)!
        self.dishes!.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section),
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: true)
        
        
    }
    
    @IBAction func switchToGridView(sender: AnyObject) {
        if !transitionInProgress{
            let visible = self.dishes.visibleCells() as! [DishCollectionViewCell]
            var toLayout : UICollectionViewLayout
            var toMode : LayoutMode
            if layoutMode == .Single{
                toMode = .Grid
                layoutButtonImg = UIImage(named: "single-view.png")
                toLayout = gridLayout
                infoPanel.hidden = true
                leftArrow.hidden = true
                rightArrow.hidden = true
            }else{
                toMode = .Single
                
                layoutButtonImg = UIImage(named: "grid-view.png")
                toLayout = singleLayout
                infoPanel.hidden = false
                leftArrow.hidden = false
                rightArrow.hidden = false
                
            }
            transitionInProgress = true
            let transition = self.dishes.startInteractiveTransitionToCollectionViewLayout(toLayout, completion: { (completed, finish) -> Void in
                if finish && completed{
                    layoutMode = toMode
                    self.setCurrentDish()
                    if let current = self.currentDish{
                        self.updateDishInfo(current)
                    }

                }
            })
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
        
        
        
            springAnimation.springBounciness = 10
            springAnimation.property = property
            springAnimation.fromValue = CGFloat(0)
            springAnimation.toValue = 1.0
            springAnimation.completionBlock = {(anim: POPAnimation!, finished: Bool) in
            if finished {
                transition.transitionProgress = 1
                self.transitionInProgress = false
                self.dishes.finishInteractiveTransition()
                
                
            }
            
        }
        self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
        
        transition.pop_addAnimation(springAnimation, forKey: NSStringFromSelector("transitionProgress"))
        
        
        
    }
    }

    
}
