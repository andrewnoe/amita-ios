//
//  NotificationStore.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/14/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

class NotificationStore {
    var notifications = [Notification]()
    
    init() {
    }
    
    func removeAll() {
        notifications.removeAll()
    }
    
    func addNotification(notification:Notification) {
        notifications.append(notification)
    }
    
    func getCount() -> Int {
        return notifications.count
    }
    
    func getNotification(index : Int) -> Notification {
        return notifications[index]
    }
    
    func removeNotification(_ notification: Notification) {
        // delete from the model
        if let index = notifications.index(of: notification) {
            notifications.remove(at: index)
        }
        
        // TODO: delete from firebase
        
    }
}
