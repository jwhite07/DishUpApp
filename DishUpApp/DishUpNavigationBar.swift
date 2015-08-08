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
        
        let logo = UIImage(named: "logo");
        let imageView = UIImageView(image:logo)
        imageView.frame.size.width = 97;
        imageView.frame.size.height = 33;
        imageView.frame.origin = CGPoint(x: 140, y: 5)
        
        addSubview(imageView)
    }
}
