//
//  NotifyGateway.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/15/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import Firebase

final internal class NotifyGateway {
    static let shared = NotifyGateway()

    let refNotify = Database.database().reference().child("Notify")
    let currentUId = Auth.auth().currentUser!.uid
    
    func addNotification(forUserId : String, message : String) {
        var newMessageMap: [String:Any] = [:]
        guard let newKey = refNotify.child(forUserId).childByAutoId().key else {
            return
        }
        newMessageMap = ["msg": message,
                         "read" : 0,
                         "added": [".sv": "timestamp"]] as [String : Any]
        let childUpdates = ["/\(self.currentUId)/\(newKey)": newMessageMap]
        refNotify.updateChildValues(childUpdates)

    }
}
