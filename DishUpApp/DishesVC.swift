//
//  DishesVC.swift
//  DishUpApp
//
//  Created by James White on 7/20/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
enum LayoutMode{
    case Single
    case Grid
}
var layoutMode  = LayoutMode.Single

class DishesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "dish"
    @IBOutlet weak var zoomLevel: UIButton!
    @IBOutlet weak var dishes: UICollectionView!
    
        var dishType:DishType?
    var restaurant:Restaurant?
    
    var dishesArray : [Dish] = []
    
    
    @IBAction func switchToGridView(sender: AnyObject) {
        if layoutMode == .Single{
            layoutMode = .Grid
            zoomLevel.setTitle("Single", forState: UIControlState.Normal)
            //scrollDirection = .Vertical
            
        }else{
            layoutMode = .Single
            zoomLevel.setTitle("Grid", forState: UIControlState.Normal)
            //scrollDirection = .Horizontal
        }
        dishes.setCollectionViewLayout(dishes.collectionViewLayout, animated: true)
        self.dishes.performBatchUpdates({
            self.dishes.reloadData()

            }, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        print("Screen Width \(screenWidth)")
        print("Screen Height \(screenHeight)")
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //layout.itemSize = CGSize(width: screenWidth, height: screenHeight)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if let dishTypeId = dishType?.id{
            Networking.getDishes(self, urlParent: "dish_types/\(dishTypeId)", completion: {self.dishes!.reloadData()})

        }else if let restaurantId = restaurant?.id{
            Networking.getDishes(self, urlParent: "restaurants/\(restaurantId)", completion: {self.dishes!.reloadData()})
            
        }else{
            Networking.getDishes(self, urlParent: nil, completion: {self.dishes!.reloadData()})
        }
        
        
               // Register cell classes
        //self.collectionView!.registerClass(DishCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    
    }
//    func dragBottomInfoPanelDown(sender : UIPanGestureRecognizer){
//        
//    }
//    func dragBottomInfoPanelUp(sender : UIScreenEdgePanGestureRecognizer){
//        var translation = sender.translationInView(sender.)
//        sender.view
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dishesArray.count
        
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let collectionWidth = self.view.frame.size.width
//        let collectionHeight = dishes.bounds.size.height
//        print (dishes.bounds.size.height)
//        var cellWidth : CGFloat
//        
//        var cellHeight : CGFloat
//        if (layoutMode == .Single){
//             cellWidth = collectionWidth
//             cellHeight = collectionHeight
//        }else{
//            cellHeight = collectionHeight / 5
//            cellWidth = cellHeight
//            
//        }
//
//        return CGSizeMake(cellWidth, cellHeight)
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        if layoutMode == .Single{
//            return 0 as CGFloat
//        }else{
//            return 1 as CGFloat
//        }
//
//    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dish : Dish
        let cellReuse : String
        dish = dishesArray[indexPath.row]

        if layoutMode == .Single{
            cellReuse = "dishSingle"
        }else{
            cellReuse = "dishGrid"
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishCollectionViewCell
        
        
        if indexPath.row == 0{
            cell.leftArrow.hidden = true
        }
        if indexPath.row == dishesArray.count - 1{
            cell.rightArrow.hidden = true
        }
        print ("IndexPath.row: \(indexPath.section)")
        
               // cell.dishPic.image = UIImage(named: "placeholder.png")
        if layoutMode == .Single{
            cell.dishName.text = dish.name.uppercaseString
           // cell.dishDesc.text = dish.description
 
        }
        cell.dish = dish

        if dish.price != nil {
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
           // cell.tag =
        }
        
//        cell.dragHandle.addGestureRecognizer(cell.dragHandleUp)
//        cell.dragHandle.addGestureRecognizer(cell.dragHandleDown)
//        cell.dragHandle.userInteractionEnabled = true

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
            if let cell = imageView.superview {
                print(cell)
                performSegueWithIdentifier("showDishDetailSegue", sender: cell)
            }
            

        }
    }

    
}
