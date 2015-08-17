//
//  DishPicZoomableCell.swift
//  DishUpApp
//
//  Created by James White on 8/14/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishPicZoomableCell: UICollectionViewCell, UIScrollViewDelegate {
    var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    weak var dishpic: Dishpic?
    weak var dish: Dish?
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
        
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width <= boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height <= boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame =  contentsFrame
        
        
    }
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }

}
