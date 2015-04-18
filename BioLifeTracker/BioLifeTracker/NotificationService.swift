//
//  NotificationService.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 18/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

class NotificationService {
    class var sharedInstance: NotificationService {
        struct Singleton {
            static let instance = NotificationService()
        }
        return Singleton.instance
    }
    
    init() {
        let notificationTypes: UIUserNotificationType = .Alert | .Badge | .Sound
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    /// Schedules notification for the next 24 hours.
    func sessionHasStarted(session: Session) {
        if session.interval == nil { return }
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let sessionExpiryTime = NSDate().dateByAddingTimeInterval(
            NSTimeInterval(1440) // 24 hours * 60 minutes per hour
        )
        var notificationTime: NSDate
        var counter = 0
        do {
            notificationTime = NSDate().dateByAddingTimeInterval(
                NSTimeInterval(session.interval!)
            )
            let notification = UILocalNotification()
            notification.fireDate = notificationTime
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "Time to take an observation!"
            notification.alertAction = "Go"
            notification.alertTitle = "BioLifeTracker"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.applicationIconBadgeNumber = 1
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            counter++
        } while counter < 128 && sessionExpiryTime.timeIntervalSinceDate(notificationTime) > 0
    }
    
    /// Cancels all notifications.
    func sessionHasEnded() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
}
