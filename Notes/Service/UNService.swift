//
//  UNService.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    // setup our singleton
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authroize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no un auth error")
            guard granted else { return }
            
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("un did receive")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("un will present")
        
        // don't need badges when our app is in the foreground
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        
        completionHandler(options)
        
    }
}
