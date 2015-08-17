//
//  DishPicCell.swift
//  DishUpApp
//
//  Created by James White on 7/31/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishpicCell: UICollectionViewCell {
    
  
    
    @IBOutlet weak var imageView: UIImageView!
    weak var dishpic: Dishpic?
    weak var dish: Dish?
    weak var indexPath: NSIndexPath?
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
        
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        //
    }

}
