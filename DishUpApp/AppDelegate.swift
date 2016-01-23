//
//  AppDelegate.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel
import Hoko






@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Mixpanel.sharedInstanceWithToken("c9f81e183e090615baf07d3bc7596316")
        Mixpanel.sharedInstance().timeEvent("Session End")
        Hoko.setupWithToken("abb81ada490053a17911cdd9441def6a6879f29b")
        //self.router = DPLDeepLinkRouter()
        Hoko.deeplinking().mapRoute("menus/:menu_id", toTarget: {
            (deeplink: HOKDeeplink) -> Void in
            if let menuIdStr = deeplink.routeParameters?["menu_id"] {
                if let menuId = Int(menuIdStr){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    let navController = storyboard.instantiateViewControllerWithIdentifier("RestaurantsNavController") as! UINavigationController
                    
                    let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
                    //
                    dishesVC.menuId = menuId
                    self.window?.rootViewController = navController
                    navController.pushViewController(dishesVC, animated: false)
                    

                }
            }
        })
        Hoko.deeplinking().mapRoute("menus/:menu_id/dishes/:dish_id", toTarget: {
            (deeplink: HOKDeeplink) -> Void in
            if let menuIdStr = deeplink.routeParameters?["menu_id"], let dishIdStr = deeplink.routeParameters?["dish_id"] {
                if let menuId =  Int(menuIdStr), let dishId = Int(dishIdStr){
                        
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let navController = storyboard.instantiateViewControllerWithIdentifier("RestaurantsNavController") as! UINavigationController
                    
                    let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
                    //
                    dishesVC.menuId = menuId
                    dishesVC.initialDishId = dishId
                    self.window?.rootViewController = navController
                    navController.pushViewController(dishesVC, animated: false)
                }

            }
        })
        Hoko.deeplinking().mapRoute("dish_types/:dish_type_id", toTarget: {
            (deeplink: HOKDeeplink) -> Void in
            if let dishTypeIdStr = deeplink.routeParameters?["dish_type_id"] {
                if let dishTypeId = Int(dishTypeIdStr){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let navController = storyboard.instantiateViewControllerWithIdentifier("DishTypesNavController") as! UINavigationController
                    
                    let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
                    //
                    dishesVC.dishTypeId = dishTypeId
                    //dishesVC.initialDishId = dishId
                    self.window?.rootViewController = navController

                }
            }
        })
        Hoko.deeplinking().mapRoute("dish_types/:dish_type_id/dishes/:dish_id", toTarget: {
            (deeplink: HOKDeeplink) -> Void in
            if let dishTypeIdStr = deeplink.routeParameters?["dish_type_id"], let dishIdStr = deeplink.routeParameters?["dish_id"] {
                if let dishTypeId =  Int(dishTypeIdStr), let dishId = Int(dishIdStr){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let navController = storyboard.instantiateViewControllerWithIdentifier("DishTypesNavController") as! UINavigationController
                    
                    let dishesVC = storyboard.instantiateViewControllerWithIdentifier("DishesStoryboardVC") as! DishesVC
                    //
                    dishesVC.dishTypeId = dishTypeId
                    dishesVC.initialDishId = dishId
                    self.window?.rootViewController = navController
                }
            }
        })


        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Mixpanel.sharedInstance().track("Session End")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Mixpanel.sharedInstance().timeEvent("Session End")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Mixpanel.sharedInstance().track("Session End")
        self.saveContext()
    }
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xxxx.ProjectName" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This core is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("coreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DishUpApp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

