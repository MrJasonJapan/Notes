//
//  AppDelegate.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        // register for remote notifications
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification")
        CKService.shared.handleNotification(with: userInfo) // handle our 'internal' notification
        // we are specifying .newData here, but it really doesn't matter (as least in our case anyways?)
        completionHandler(.newData)
    }

}

