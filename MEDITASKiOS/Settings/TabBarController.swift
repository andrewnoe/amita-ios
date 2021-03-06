//
//  TabBarController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 8/9/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    let refNotify = Database.database().reference().child("Notify")
    let currentUId = Auth.auth().currentUser!.uid
    //var currentUser = MockUser(senderId: Auth.auth().currentUser!.uid, displayName: "")

    //var notifyList: [Notification] = []
    var notificationStore: NotificationStore!
    var dvc : NotifyTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBar.items?[0].title = "Tasks"
     //   tabBar.items?[1].title = "Patients"
        notificationStore = NotificationStore()
        let destinationViewController = viewControllers?[3] as! NotifyViewController // or whatever tab index you're trying to access
        dvc = (destinationViewController.viewControllers[0] as! NotifyTableViewController)
        dvc.notificationStore = self.notificationStore
        fetchNotifications()
    }
    
    func fetchNotifications() {
        let queryNotify = self.refNotify.child(currentUId).queryOrdered(byChild: "added")
        queryNotify.observe(DataEventType.value, with: { (snapshot) in
            self.tabBar.items![3].badgeValue = nil
            self.notificationStore.removeAll()
            var counter = 0
            for notification in snapshot.children.allObjects as! [DataSnapshot] {
                guard let notificationInfo = notification.value as? [String: Any]
                    else {
                        return
                }
                //print("*** \(notificationInfo)")
                
                let msg = notificationInfo["msg"] as? String
                let added:Int = notificationInfo["added"] as! Int
                let read:Bool = notificationInfo["read"] as! Bool
                let notification = Notification(notifyId: notification.key, msg: msg!, added: added, read: read)
                self.notificationStore.addNotification(notification: notification)
                
                counter += 1
                if (counter == snapshot.childrenCount) {
                    self.tabBar.items![3].badgeValue = String(self.notificationStore.getCount())
                    
                    //var tabBarController = segue.destination as UITabBarController
                    self.dvc.tableView.reloadData()
                }
            }
        })
    }
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(segue.identifier)")
        //if segue.identifier == "segueIdInStoryboard" {
            if let DVC = segue.destination as? NotifyViewController {
                DVC.notifyList = notifyList
            }
            //else {
              //  print("Data NOT Passed! destination vc is not set to firstVC")
            //}
        //} else { print("Id doesnt match with Storyboard segue Id") }
    }
*/
}
