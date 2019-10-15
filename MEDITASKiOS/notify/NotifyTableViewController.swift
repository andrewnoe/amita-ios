//
//  NotifyTableViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/11/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NotifyTableViewController : UITableViewController {
    //var myarray: [String] = []
    var notificationStore : NotificationStore!
    
    let refNotify = Database.database().reference().child("Notify")
    let currentUId = Auth.auth().currentUser!.uid

   
    @IBAction func addTestNotification(_ sender: Any) {
        // var newMessageMap: [String:Any] = [:]
        DispatchQueue.global(qos: .default).async {
            NotifyGateway.shared.addNotification(forUserId: self.currentUId, message: "Test Notification")
            /*
            guard let newKey = self.refNotify.child(self.currentUId).childByAutoId().key else {
                return
            }
            newMessageMap = ["msg": "Test Notification",
                             "read" : 0,
                             "added": [".sv": "timestamp"]] as [String : Any]
            let childUpdates = ["/\(self.currentUId)/\(newKey)": newMessageMap]
            self.refNotify.updateChildValues(childUpdates)
 */
        }
    }
    
    override func viewDidLoad() {
        // myarray = ["item1", "item2", "item3"]
        
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //notificationStore.
            let notification = notificationStore.notifications[indexPath.row]
            notificationStore.removeNotification(notification)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            refNotify.child(currentUId).child(notification.notifyId).removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationStore.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifyTableCell", for: indexPath)
        let notification = notificationStore.getNotification(index: indexPath.item)
        cell.textLabel?.text = notification.msg
        //cell.notificationId = notification.notifyId
        //cell.notificationLabel.text = notifyList[indexPath.item].msg
        return cell
    }
}
