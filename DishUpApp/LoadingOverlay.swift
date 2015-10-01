//
//  LoadingOverlay.swift
//  DishUpApp
//
//  Created by James White on 9/2/15.
//  Copyright © 2015 James White. All rights reserved.
//

import Foundation
import UIKit
public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        var yoffset = screenHeight / CGFloat(3.0)
        
        
        overlayView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(red:0.22, green:0.45, blue:0.55, alpha:0.76)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        let cup = UIImageView()
        cup.image = UIImage(named: "Mug.png")
        cup.frame = CGRectMake((screenWidth - 75) / 2, yoffset, 93, 90)
        cup.contentMode = .ScaleAspectFit
        
        yoffset += 160
        
        let text = UILabel(frame: CGRectMake(0, 0, 200, 75))
        
        text.text = "GIVE US A MINUTE... \n WE'RE CONTACTING THE ALIENS \n THAT MAKE THIS ALL POSSIBLE."
        text.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
        text.textColor = UIColor(white: 1.0, alpha: 1.0)
        text.textAlignment = .Center
        text.numberOfLines = 0
        text.center = CGPointMake(screenWidth / 2, yoffset )
        
        yoffset += 100
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, yoffset)
        overlayView.addSubview(cup)
        overlayView.addSubview(text)
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}