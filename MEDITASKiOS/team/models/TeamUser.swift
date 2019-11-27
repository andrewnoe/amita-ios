//
//  TeamUser.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

internal class TeamUser: NSObject {
    var userId: String
    var dayShift: Bool
    var nightShift: Bool
    var filterOn: Bool
    
    init(userId: String, dayShift: Bool, nightShift: Bool, filterOn: Bool) {
        self.userId = userId
        self.dayShift = dayShift
        self.nightShift = nightShift
        self.filterOn = filterOn
        super.init()
    }
}
