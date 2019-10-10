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

    var notifyList: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBar.items?[0].title = "Tasks"
     //   tabBar.items?[1].title = "Patients"

        // Do any additional setup after loading the view.
        
        // maybe this is where we should hook up notifications?
        fetchNotifications()
    }
    
    func fetchNotifications() {
        let queryNotify = self.refNotify.child(currentUId).queryOrdered(byChild: "added")
        queryNotify.observe(DataEventType.value, with: { (snapshot) in
            self.notifyList.removeAll()
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
                self.notifyList.append(notification)
                
                counter += 1
                if (counter == snapshot.childrenCount) {
                    print("*** count of notifications \(self.notifyList.count)")
                    
                    // update GUI list or something
                }
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
