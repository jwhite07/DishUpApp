//
//  DishPicsVC.swift
//  DishUpApp
//
//  Created by James White on 8/13/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishPicsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate {
    var dish:Dish?
    var startIndex: NSIndexPath?

    @IBOutlet weak var dishpics: UICollectionView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    @IBAction func leftArrowTap(sender: AnyObject) {
        let point = CGPointMake(dishpics.frame.width / 2 + dishpics.contentOffset.x, dishpics.frame.height / 2 )
        var indexPath : NSIndexPath = dishpics.indexPathForItemAtPoint(point)!
        if indexPath.row == 0{
            indexPath = NSIndexPath(forItem: dish!.dishpics.count - 1, inSection: indexPath.section)
        }else{
            indexPath = NSIndexPath(forItem: indexPath.row - 1, inSection: indexPath.section)
        }
        self.dishpics!.scrollToItemAtIndexPath(indexPath,
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: false)

    }
    @IBAction func rightArrowTap(sender: AnyObject) {
        let point = CGPointMake(dishpics.frame.width / 2 + dishpics.contentOffset.x, dishpics.frame.height / 2 )
        var indexPath : NSIndexPath = dishpics.indexPathForItemAtPoint(point)!
        if indexPath.row == dish!.dishpics.count - 1{
            indexPath = NSIndexPath(forItem: 0, inSection: indexPath.section)
        }else{
            indexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
        }
        self.dishpics!.scrollToItemAtIndexPath(indexPath,
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: false)

    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        dishpics.frame =  UIScreen.mainScreen().bounds
        if dish!.dishpics.count < 2{
            rightArrow.hidden = true
            leftArrow.hidden = true
        }
        self.automaticallyAdjustsScrollViewInsets = false
                
    }
    override func viewDidLayoutSubviews() {
        if let indexPath = startIndex{
            dishpics.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        }
    }
        
        
        

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dish!.dishpics.count
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = self.dishpics.frame.size.height
        let width = self.dishpics.frame.size.width
        print("cell height: \(height) cell width: \(width)")
        return CGSizeMake(width, height)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dishpic : Dishpic
        let cellReuse = "dishpic"
        dishpic = dish!.dishpics[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuse, forIndexPath: indexPath) as! DishPicZoomableCell
        print ("IndexPath.row: \(indexPath.section)")
        if let url = Networking.sanitizeUrlFromString(dishpic.url){
            cell.imageView = UIImageView()
            for sub in cell.scrollView.subviews{
                sub.removeFromSuperview()
            }
            cell.scrollView.addSubview(cell.imageView)

            cell.imageView.sd_setImageWithURL(url, completed: {
                (image, error, type, url) -> Void in
                
                cell.imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
                
                // 2
                cell.scrollView.contentSize = image.size
                
                // 3
                var doubleTapRecognizer = UITapGestureRecognizer(target: cell, action: "scrollViewDoubleTapped:")
                doubleTapRecognizer.numberOfTapsRequired = 2
                doubleTapRecognizer.numberOfTouchesRequired = 1
                cell.scrollView.addGestureRecognizer(doubleTapRecognizer)
                
                cell.scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size)
                // 4
                let scrollViewFrame = cell.scrollView.frame
                print("scrollView Size: \(cell.scrollView.frame.size)")
                let scaleWidth = scrollViewFrame.size.width / cell.scrollView.contentSize.width
                let scaleHeight = scrollViewFrame.size.height / cell.scrollView.contentSize.height
                let minScale = min(scaleWidth, scaleHeight);
                
                cell.scrollView.minimumZoomScale = minScale;
                print("scrollView Frame: \(scrollViewFrame) dishpicsFrame: \(self.dishpics.frame) cell frame: \(cell.frame) imageView frame: \(cell.imageView.frame) imageSize: \(image.size)")
                // 5
                cell.scrollView.maximumZoomScale = 1.0
                cell.scrollView.zoomScale = minScale;
                
                // 6
                cell.centerScrollViewContents()
                print("imageView frmae: \(cell.imageView.frame)")
            })
        }
        
        
        cell.dishpic = dishpic
        
        
        
        return cell
    }
    
    
}
