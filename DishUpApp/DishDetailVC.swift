//
//  DishDetailVC.swift
//  DishUpApp
//
//  Created by James White on 7/31/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit
import Cosmos


class DishDetailVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let reuseIdentifier = "dish"
    var dish:Dish?
    
    @IBOutlet weak var dishpics: UICollectionView!
    

    @IBOutlet weak var dishRating: CosmosView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishDesc: UILabel!
    @IBOutlet weak var restarauntName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantCityStZip: UILabel!

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let dishSafe = self.dish{
            updateSubViews(dishSafe)
            Networking.getDishDetails(self, dishId: dishSafe.id, completion: {
                self.dishpics.reloadData()
                self.updateSubViews(self.dish!)
            })
        }
    }
   
    func updateSubViews(dish: Dish) {
        self.dishRating.rating      = dish.rating.doubleValue
        self.dishName.text          = dish.name
        if dish.price != nil {
            self.dishPrice.text = dish.price!.stringValue
        }else{
            self.dishPrice.text = nil
        }
        
        self.dishDesc.text          = dish.description
        
        self.restarauntName.text    = dish.restaurant?.name
        self.restaurantAddress.text = dish.restaurant?.address
        self.restaurantCityStZip.text = "\(dish.restaurant?.city), \(dish.restaurant?.state) \(dish.restaurant?.postal_code)"
    
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
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dish!.dishpics.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dishpic : Dishpic
        let cellReuse = "dishpic"
        dishpic = dish!.dishpics[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishpicCell
        print ("IndexPath.row: \(indexPath.section)")
        
        cell.imageView.image = UIImage(named: "placeholder.png")
        Networking.getImageAtUrl(dishpic.url, completion:
            {(imageObj: UIImage) in
                cell.imageView.image = imageObj
                
        })
        cell.dishpic = dishpic

        
        
        return cell
    }


}
