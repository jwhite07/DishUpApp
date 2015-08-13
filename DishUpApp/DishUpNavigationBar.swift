//
//  DishUpNavigationBar.swift
//  DishUpApp
//
//  Created by James White on 8/7/15.
//  Copyright © 2015 James White. All rights reserved.
//

import UIKit

class DishUpNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
        initialise()
    }
    
    func initialise(){
        
        let logo = UIImage(named: "dishupLogo.png")
        let imageView = UIImageView(image:logo)
        let logoWidth : CGFloat = 99
        imageView.frame.size.width = logoWidth
        
        imageView.frame.size.height = 33         
        let xStart = UIScreen.mainScreen().bounds.width / 2 - logoWidth / 2
        imageView.frame.origin = CGPoint(x: xStart, y: 5)
        //print("frame width: \(superview!.frame.size.width) logoWidth: \(logoWidth) xStart: \(xStart) frame: \(imageView.frame)")

        
        
        addSubview(imageView)
//        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    }
    
}
