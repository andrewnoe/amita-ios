//
//  TeamUser.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

internal class TeamUser: NSObject {
    var userId: String //users unique id
    var dayShift: Bool //Boolean that assigns you to day team
    var nightShift: Bool //Boolean that assigns you to team and assigns all tasks of said team to you
    var filterOn: Bool //in case of multiple teams, filters available tasks based on Boolean value (Currently unused)
    
    init(userId: String, dayShift: Bool, nightShift: Bool, filterOn: Bool) {
        self.userId = userId
        self.dayShift = dayShift
        self.nightShift = nightShift
        self.filterOn = filterOn
        super.init()
    }
}
