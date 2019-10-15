//
//  Notification.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/4/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

internal class Notification: NSObject {
    var notifyId: String
    var msg: String
    var added: Int
    var read: Bool

    init(notifyId: String, msg: String, added: Int, read: Bool) {
        self.notifyId = notifyId
        self.msg = msg
        self.added = added
        self.read = read
        
        super.init()
    }
}
