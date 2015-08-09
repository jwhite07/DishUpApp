//
//  NavigationFlipTransitionController.swift
//  DishUpApp
//
//  Created by James White on 8/9/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import QuartzCore

class NavigationFlipTransitionController: NSObject,  UIViewControllerAnimatedTransitioning{
    let animationDuration = 0.5
    var animating = false
    var operation: UINavigationControllerOperation = .Push
    
    weak var storedContext: UIViewControllerContextTransitioning? = nil
    
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //
        storedContext = transitionContext
        if(operation == .Push){
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController?
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController?
            
            //transitionContext.containerView()!.addSubview(toVC!.view)
            
                       
            
            UIView.transitionFromView(fromVC!.view, toView: toVC!.view, duration: animationDuration, options: (.TransitionFlipFromRight), completion: nil)
        }else{
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController?
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController?
            
            //transitionContext.containerView()!.addSubview(toVC!.view)
            
            
            
            UIView.transitionFromView(fromVC!.view, toView: toVC!.view, duration: animationDuration, options: (.TransitionFlipFromLeft), completion: nil)

        }
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext{
            context.completeTransition(!context.transitionWasCancelled())
        }
        storedContext = nil
        animating = false
    }
   
}
