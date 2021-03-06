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
import AMPopTip
import Mixpanel
//import Hoko

enum LayoutMode{
    case Single
    case Grid
}
var layoutMode  = LayoutMode.Single
var layoutButtonImg = UIImage(named: "grid-view.png")
var currentIndexPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
var targetIndexPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
var targetGridOffset = CGPointZero
let dishesGlobal : UICollectionView? = nil

class DishesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    let reuseIdentifier = "dish"
    @IBOutlet weak var zoomLevel: UIButton!
    @IBOutlet weak var dishes: UICollectionView!
    
    var transitionLayout : UICollectionViewTransitionLayout?
    var transitionInProgress = false
    var dishType:DishType?
    var dishTypeId:Int?
    var restaurant:Restaurant?
    var menuId:Int?
    var initialDishId:Int?
    var loadingContent = false
    
    var dishesArray : [Dish] = []
    var dishesFullArray : [Dish] = []
//    let transition = NavigationFlipTransitionController()
    let singleLayout = DishesSingleLayout()
    let gridLayout = DishesGridLayout()

    
    var lastContentOffset : CGFloat = 0
    var currentDish : Dish?
    var nextDish : Dish?
    var hideLeftArrowNext = false
    var hideRightArrowNext = false
    var hideLeftArrowCurrent = false
    var hideRightArrowCurrent = false
    
    @IBOutlet weak var dishesSearch: UISearchBar!
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    @IBOutlet weak var currentDishName: UILabel!
    @IBOutlet weak var currentDishPrice: UILabel!
    @IBOutlet weak var currentDishRating: CosmosView!
    
    @IBOutlet weak var nextDishName: UILabel!
    @IBOutlet weak var nextDishRating: CosmosView!
    @IBOutlet weak var nextDishPrice: UILabel!
    @IBAction func switchToGridView(sender: AnyObject) {
        targetIndexPath = currentIndexPath
        transitionSingleGridLayouts()
    }
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func copyDeepLink(sender: AnyObject) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        print( "\(image)")
        UIGraphicsEndImageContext()
        
        if layoutMode == .Grid{
            if let menu_id = menuId{
//                let deeplink = HOKDeeplink(route: "menus/:menu_id", routeParameters: ["menu_id": String(menu_id)])
//                Hoko.deeplinking().generateSmartlinkForDeeplink(deeplink, success: { (smartlink: String) -> Void in
//                    let shareMessage = "Check out \(self.restaurant!.name)'s menu on DishUp!"
//                    let shareController = UIActivityViewController(activityItems: [shareMessage, smartlink, image], applicationActivities: nil)
//                    self.presentViewController(shareController, animated: true, completion: nil)
//                    
//                    }) { (error: NSError) -> Void in
//                    UIPasteboard.generalPasteboard().string = "dishup://menus/\(menu_id)"
//                }

            }
            if let dish_type_id = dishTypeId{
//                let deeplink = HOKDeeplink(route: "dish_types/:dish_type_id", routeParameters: ["dish_type_id": String(dish_type_id)])
//                Hoko.deeplinking().generateSmartlinkForDeeplink(deeplink, success: { (smartlink: String) -> Void in
//                    let shareMessage = "Check out these awesome looking \(self.dishType!.name) on DishUp!"
//                    let shareController = UIActivityViewController(activityItems: [shareMessage, smartlink, image], applicationActivities: nil)
//                    self.presentViewController(shareController, animated: true, completion: nil)
//                    
//                    }) { (error: NSError) -> Void in
//                        UIPasteboard.generalPasteboard().string = "dishup://dish_types/\(dish_type_id)"
//                }
                
            }
        }else if layoutMode == .Single && currentDish != nil{
            if let menu_id = menuId{
//                let deeplink = HOKDeeplink(route: "menus/:menu_id", routeParameters: ["menu_id": String(menu_id), "dish_id": String(currentDish!.id)])
//                Hoko.deeplinking().generateSmartlinkForDeeplink(deeplink, success: { (smartlink: String) -> Void in
//                    let shareMessage = "The \(self.currentDish!.name) at \(self.currentDish!.restaurant_name!) looks amazing, check it out on DishUp!"
//                    let shareController = UIActivityViewController(activityItems: [shareMessage, smartlink, image], applicationActivities: nil)
//                    self.presentViewController(shareController, animated: true, completion: nil)
//                    
//                    }) { (error: NSError) -> Void in
//                        UIPasteboard.generalPasteboard().string = "dishup://menus/\(menu_id)/dishes/\(self.currentDish?.id)"
//                }
                
            }
            if let dish_type_id = dishTypeId{
//                let deeplink = HOKDeeplink(route: "dish_types/:dish_type_id", routeParameters: ["dish_type_id": String(dish_type_id), "dish_id": String(currentDish!.id)])
//                Hoko.deeplinking().generateSmartlinkForDeeplink(deeplink, success: { (smartlink: String) -> Void in
//                    let shareMessage = "The \(self.currentDish!.name) at \(self.currentDish!.restaurant_name!) looks amazing, check it out on DishUp!"
//                    let shareController = UIActivityViewController(activityItems: [shareMessage, smartlink, image], applicationActivities: nil)
//                    self.presentViewController(shareController, animated: true, completion: nil)
//                    
//                    }) { (error: NSError) -> Void in
//                        UIPasteboard.generalPasteboard().string = "dishup://dish_types/\(dish_type_id)/dishes/\(self.currentDish?.id)"
//                }
                
            }

        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.viewScreen("Dishes View")
        
    }
    override func viewDidLoad() {
        loadingContent = true
        super.viewDidLoad()
        if layoutMode == .Single{
            dishes.setCollectionViewLayout(singleLayout, animated: false)
        }else{
            dishes.setCollectionViewLayout(gridLayout, animated: false)
        }
        

        let loadComplete : () -> () = {
            
            self.dishes!.reloadData()
            self.dishesArray = self.dishesFullArray
            let relativeFrame = CGRectMake(screenWidth - 52, self.zoomLevel.frame.origin.y + 64, self.zoomLevel.frame.width, self.zoomLevel.frame.height)
            if layoutMode == .Single{
//                self.infoPanel.hidden = false
//                self.leftArrow.hidden = false
//                self.rightArrow.hidden = false
                print("call set current dish at line 78")

                self.setCurrentDish()
                if let current = self.currentDish{
                    self.updateDishInfo(current)
                }
            }else{
                
                for const in self.rightArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.TrailingMargin{
                        const.constant =  -self.rightArrow.frame.width - 20
                    }
                    
                }
                for const in self.leftArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.Leading{
                        const.constant = -self.leftArrow.frame.width - 20
                    }
                    
                }
                for const in self.infoPanel.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Vertical){
                    if const.firstAttribute == NSLayoutAttribute.Top{
                        const.constant =  -self.infoPanel.frame.height
                    }
                }
            }
            onboarding.displayOnboardingPopTip(
                "Tap to see all dishes",
                direction: AMPopTipDirection.Down,
                inView: self.view,
                fromFrame: relativeFrame,
                key: "zoomLevelIntro",
                onDismiss: {
                    onboarding.displayOnboardingPopTip(
                        "Tap any image to see more detail about the dish",
                        direction: AMPopTipDirection.None,
                        inView: self.view,
                        fromFrame: self.view.frame,
                        key: "tapForDishDetails",
                        onDismiss: {
                            onboarding.displayOnboardingPopTip(
                                "Tap or swipe to browse the menu",
                                direction: AMPopTipDirection.None,
                                inView: self.view,
                                fromFrame: self.view.frame,
                                key: "swipeInstructions",
                                onDismiss: nil
                            )
                        }
                    )
                }
            )
            self.loadingContent = false
        }
        
        if let dtId = dishType?.id{
            dishTypeId = dtId
        }
        if let restId = restaurant?.menu_id{
            menuId = restId
        }
        print("dish type id: \(dishTypeId) menuID: \(menuId)")
        if  dishTypeId != nil{
            Networking.getDishes(self, urlParent: "dish_types/\(dishTypeId!)", completion: loadComplete)
        }else if  menuId != nil{
            Networking.getDishes(self, urlParent: "menus/\(menuId!)", completion: loadComplete)
        }else{
            Networking.getDishes(self, urlParent: nil, completion: loadComplete)
        }
        self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
        lastContentOffset = dishes.contentOffset.x
        dishesSearch.delegate = self
self.automaticallyAdjustsScrollViewInsets = false
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dishesArray = searchText.isEmpty ? dishesFullArray : dishesFullArray.filter(){
            if let name = ($0 as Dish).name as String! {
                print("searchText: \(searchText) name: \(name) range: \(name.rangeOfString(searchText))")
                return name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            }else{
                return false
            }
        }
        
        dishes.reloadData()
    }

    @IBAction func handleCellPinch(recognizer: UIPinchGestureRecognizer) {
//        if recognizer.state == UIGestureRecognizerState.Ended{
//            if !transitionInProgress{
//                if layoutMode == .Single{
//                    targetIndexPath = currentIndexPath
//                    transitionSingleGridLayouts()
//                }
//            }
//
//        }
    }
    func setCurrentDish(){
                    //print("dishes: \(dishes.frame) content offset: \(dishes.contentOffset)")
            let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
            if let indexPath = dishes.indexPathForItemAtPoint(point){
                currentDish = dishesArray[indexPath.row]
                currentIndexPath = indexPath
                //print("current Dish Name: \(currentDish!.name) current indexPath: \(currentIndexPath)")
                setArrowsForIndexPath(indexPath)
                
            }
       

    }
    func setArrowsForIndexPath(indexPath: NSIndexPath){
        if indexPath.row == 0{
            leftArrow.alpha = 0
            hideLeftArrowCurrent = true
        }else{
            hideLeftArrowCurrent = false
            leftArrow.alpha = 1
        }
        if indexPath.row == dishesArray.count - 1{
            rightArrow.alpha = 0
            hideRightArrowCurrent = true
        }else{
            hideRightArrowCurrent = false
            rightArrow.alpha = 1
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
        if let dishpic = dish.lead_dishpic_url{
            if let url = Networking.sanitizeUrlFromString(dish.lead_dishpic_url!){
                cell.dishPic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder.png"))
                
            }

        }
        cell.indexPath = indexPath
        cell.collectionView = dishes
        if let recs = cell.gestureRecognizers{
            for rec in recs{
                cell.removeGestureRecognizer(rec)
            }

        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleCellTap:")
        cell.addGestureRecognizer(tapRecognizer)
        return cell
    }
    
    func updateDishInfo(dish: Dish){
        self.currentDishName.text = dish.name.uppercaseString
       // self.currentDishRating.rating = dish.rating.doubleValue
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
        //disabling ratings for now
        //currentDishRating.alpha = 1
        nextDishName.alpha = 0
        nextDishPrice.alpha = 0
       // nextDishRating.alpha = 0
        var analyticsProps = ["Name":dish.name]
        if let rest = self.restaurant{
            analyticsProps["Restaurant"] = rest.name
            
        }
        if let dt = self.dishType{
            analyticsProps["Dish Type"] = dt.name
        }
        Analytics.trackEvent("Saw Dish", properties: analyticsProps )

    }
    func updateNextDish(dish: Dish){
        self.nextDishName.text = dish.name.uppercaseString
       // self.nextDishRating.rating = dish.rating.doubleValue
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
        if layoutMode == .Single && !transitionInProgress{
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
           // print("scrollViewOffset: \(scrollView.contentOffset.x) lastOffset: \(self.lastContentOffset) destOffset: \(destOffset) percentage: \(percentage)")

            if let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point){
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
            }
            //print("offset: \(scrollView.contentOffset.x) ")
            //print("current Dish: \(currentDish?.name) next Dish: \(nextDish?.name)")
        }
        
        
    }
    
    func scrollViewDidScrolltoPercentageOffset(perc: CGFloat){
        let inv = 1 - perc
        currentDishName.alpha = inv
        currentDishPrice.alpha = inv
        //currentDishRating.alpha = inv
        nextDishName.alpha = perc
        nextDishPrice.alpha = perc
        //nextDishRating.alpha = perc
        
        
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
            print("call set current dish at line 269")

            setCurrentDish()
            updateDishInfo(currentDish!)
            

        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if layoutMode == .Single{
            if !decelerate{
                self.lastContentOffset = dishes.contentOffset.x
                print("call set current dish at line 279")

                setCurrentDish()
                updateDishInfo(currentDish!)
            }
 
        }
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if layoutMode == .Single{
            self.lastContentOffset = dishes.contentOffset.x
            print("call set current dish at line 288")

            setCurrentDish()
            updateDishInfo(currentDish!)

        }
    }
    func handleCellTap(recognizer: UITapGestureRecognizer) {
        if !transitionInProgress{
            let tapPoint = recognizer.locationOfTouch(0, inView: dishes)
            if let indexPath = dishes.indexPathForItemAtPoint(tapPoint){
                if layoutMode == .Single{
                    let cell =  self.dishes.cellForItemAtIndexPath(indexPath)
                    
                    performSegueWithIdentifier("showDishDetailSegue", sender:cell)
                    
                }else{
                    currentIndexPath = indexPath
                    targetIndexPath = currentIndexPath
                    transitionSingleGridLayouts()
                    
                }

            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            var props : [String : String] = [:]
            if segue.identifier == "showDishDetailSegue" {
                let cell = sender as! DishCollectionViewCell
                let dishDetailVC = segue.destinationViewController as! DishDetailVC
                dishDetailVC.dish = cell.dish
                dishDetailVC.restaurant = self.restaurant
                
                props[ "Dish"] = cell.dish?.name
                props["Restaurant"] = cell.dish?.restaurant_name
                props["Craving"] = self.dishType?.name
                
                
            }
            props["Identifier"] = id
            Analytics.trackEvent("Segue From Dishes Screen ", properties: props)
        }

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
        if !loadingContent{
            let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
            let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point)!
            if indexPath != 0 {
                self.dishes!.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row - 1, inSection: indexPath.section),
                    atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
                    animated: true)
                
            }

        }
        
    }
    @IBAction func tapRightArrow(sender: AnyObject) {
        if !loadingContent{
            let point = CGPointMake(dishes.frame.width / 2 + dishes.contentOffset.x, dishes.frame.height / 2 )
            let indexPath : NSIndexPath = dishes.indexPathForItemAtPoint(point)!
            if indexPath != dishesArray.count - 1 {
                self.dishes!.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section),
                    atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
                    animated: true)
                
            }
 
        }
        
    }
    func popAnimationForAxis(fromValue: CGFloat, toValue: CGFloat) -> POPAnimation{
        let animation = POPSpringAnimation()
        
        let property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
        animation.springBounciness = 10
        animation.property = property
        animation.fromValue = fromValue
        animation.toValue = toValue
       // animation.springSpeed = 200
        return animation
    }

    func transitionSingleGridLayouts(){
        if !transitionInProgress && !loadingContent{
            
            let visible = self.dishes.visibleCells() as! [DishCollectionViewCell]
            var toLayout : UICollectionViewLayout
            var toMode : LayoutMode
            var direction : String = ""
            
            
            if layoutMode == .Single{
                toMode = .Grid
                layoutButtonImg = UIImage(named: "single-view.png")
                toLayout = gridLayout
                direction = "Grid"
            }else{
                toMode = .Single
                layoutButtonImg = UIImage(named: "grid-view.png")
                toLayout = singleLayout
                direction = "Single"
            }
            
            transitionInProgress = true
            var transitionProps = ["Direction":direction]
            

            if layoutMode == .Grid{
                print("Before - leftArrow alpha: \(leftArrow.alpha) leftArrow hidden: \(leftArrow.hidden)")
                setArrowsForIndexPath(targetIndexPath)
                print("After - leftArrow alpha: \(leftArrow.alpha) leftArrow hidden: \(leftArrow.hidden)")
                self.updateDishInfo(dishesArray[targetIndexPath.item])
                transitionProps["Dish"] = dishesArray[targetIndexPath.item].name
            }
            Analytics.trackEvent("Toggle Dishes Grid/Single", properties: transitionProps)
            let transition = self.dishes.startInteractiveTransitionToCollectionViewLayout(toLayout, completion: { (completed, finish) -> Void in
                if finish && completed{
                    layoutMode = toMode
                    self.transitionInProgress = false
                    if layoutMode == .Single{
                        self.dishes.pagingEnabled = true
                        self.dishes.contentOffset = CGPointMake( CGFloat(targetIndexPath.row) * screenWidth,  0)
                        self.setCurrentDish()
                        
                        
                    }else{
                        self.dishes.pagingEnabled = false
                        self.dishes.contentOffset = targetGridOffset
                    }
                    print("call set current dish at line 379")
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
           // springAnimation.springSpeed = 10
            springAnimation.completionBlock = {(anim: POPAnimation!, finished: Bool) in
                if finished {
                    transition.transitionProgress = 1
                    
                    self.dishes.finishInteractiveTransition()
                }
            }
            self.zoomLevel.setImage(layoutButtonImg, forState: UIControlState.Normal)
            transition.pop_addAnimation(springAnimation, forKey: NSStringFromSelector("transitionProgress"))
            
            if layoutMode == .Single {
                for const in rightArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.TrailingMargin{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: -rightArrow.frame.width - 20), forKey: "kPopLayoutConstraintConstant")
                    }
                    
                }
                for const in leftArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.Leading{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: -leftArrow.frame.width - 20), forKey: "kPopLayoutConstraintConstant")
                    }
                    
                }
                for const in infoPanel.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Vertical){
                    if const.firstAttribute == NSLayoutAttribute.Top{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: -infoPanel.frame.height), forKey: "kPopLayoutConstraintConstant")
                    }
                }
            }else{
                for const in rightArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.TrailingMargin{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: 0), forKey: "kPopLayoutConstraintConstant")
                    }
                    
                }
                for const in leftArrow.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Horizontal){
                    if const.firstAttribute == NSLayoutAttribute.Leading{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: 0), forKey: "kPopLayoutConstraintConstant")
                    }
                    
                }
                for const in infoPanel.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Vertical){
                    if const.firstAttribute == NSLayoutAttribute.Top{
                        const.pop_addAnimation(popAnimationForAxis(const.constant, toValue: 0), forKey: "kPopLayoutConstraintConstant")
                    }
                    
                }

                
            }
            
            
            
        }
        
            }
}
