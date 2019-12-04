//
//  TaskStore.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 12/3/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

class TaskStore {
    var tasks = [Task]()
    
    init() {
    }
    
    func removeAll() {
        tasks.removeAll()
    }
    
    func addTask(task:Task) {
        tasks.append(task)
    }
    
    func getCount() -> Int {
        return tasks.count
    }
    
    func getTask(index : Int) -> Task {
        return tasks[index]
    }
    
    func removeTask(_ task: Task) {
        // delete from the model
        if let index = tasks.index(of: task) {
            tasks.remove(at: index)
        }
    }
    
}
