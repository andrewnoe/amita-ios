//
//  Task.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 12/3/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

internal class Task: NSObject {
    var taskId: String
    var taskName: String
    
    init(taskId: String, taskName: String) {
        self.taskId = taskId
        self.taskName = taskName
        
        super.init()
    }
}
