//
//  Analytics.swift
//  DishUpApp
//
//  Created by James White on 1/23/16.
//  Copyright © 2016 James White. All rights reserved.
//

import Foundation
import Mixpanel

class Analytics {
    static func trackEvent(tag: String, properties: [String:String]){
        Mixpanel.sharedInstance().track(tag, properties: properties)
        Localytics.tagEvent(tag, attributes: properties)
    }
    static func viewScreen(screenName: String){
        Localytics.setLoggingEnabled(true)
        Localytics.tagScreen(screenName)
        Localytics.upload()
    }
}