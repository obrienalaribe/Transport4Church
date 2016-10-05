//
//  LocalNotificationHelper.swift
//  Transport4Church
//
//  Created by mac on 10/4/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class NotificationHelper: NSObject {
    
    func checkNotificationEnabled() -> Bool {
        // Check if the user has enabled notifications for this app and return True / False
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return false}
        if settings.types == .None {
            return false
        } else {
            return true
        }
    }
    
    func checkNotificationExists(taskTypeId: String) -> Bool {
        // Loop through the pending notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            // Find the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                return true
            }
        }
        return false
        
    }
    
    static func setupNotification(){
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    
    static func scheduleLocal(message: String, status: String, alertDate: NSDate) {
        let notification = UILocalNotification()
        notification.fireDate = alertDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(message)"
//        notification.alertAction = "Due : \(alertDate)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["status": status]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        print("Notification set for message: \(message) at \(alertDate)")
    }
    
    func removeNotification(taskTypeId: String) {
        
        // loop through the pending notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            // Cancel the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                
                print("Notification deleted for taskTypeID: \(taskTypeId)")
                
                break
            }
        }
    }
    
    func listNotifications() -> [UILocalNotification] {
        var localNotify:[UILocalNotification]?
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            localNotify?.append(notification)
        }
        return localNotify!
    }
    
    func printNotifications() {
        
        print("List of notifications currently set:- ")
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            print ("\(notification)")
        }
    }
}
