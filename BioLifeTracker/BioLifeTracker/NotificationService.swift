//
//  NotificationService.swift
//  BioLifeTracker
//
//  Created by Andhieka Putra on 18/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation

/// This class provides notification service during observation taking.
/// It will call notification for a specified time interval.
class NotificationService {
    
    // Constants
    let timeInterval = Double(1440*60) // 24 hours * 60 minutes per hour
    let minToSec = 60
    let alertMsg = "Time to take an observation!"
    let actionStr = "Go"
    let titleStr = "BioLifeTracker"
    let maxCounter = 128
    
    /// Implementation of Singleton Pattern
    class var sharedInstance: NotificationService {
        struct Singleton {
            static let instance = NotificationService()
        }
        return Singleton.instance
    }
    
    /// Initiates a NotificationService instance
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
            NSTimeInterval(timeInterval)
        )
        var notificationTime: NSDate
        var counter = 1
        do {
            notificationTime = NSDate().dateByAddingTimeInterval(
                NSTimeInterval(counter * session.interval! * minToSec)
            )
            let notification = UILocalNotification()
            notification.fireDate = notificationTime
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = alertMsg
            notification.alertAction = actionStr
            notification.alertTitle = titleStr
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.applicationIconBadgeNumber = 1
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            counter++
        } while counter <= maxCounter && sessionExpiryTime.timeIntervalSinceDate(notificationTime) > 0
    }
    
    /// Cancels all notifications.
    func sessionHasEnded() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
}
