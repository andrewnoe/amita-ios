//
//  Team.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

internal class Team: NSObject {
    var teamId: String
    var teamName: String
    var userIds: [TeamUser]
    
    init(teamId: String, teamName: String) {
        self.teamId = teamId
        self.teamName = teamName

        self.userIds = []
        
        super.init()
    }
    
    func addTeamUser(teamUser: TeamUser) {
        userIds.append(teamUser)
    }
    
    func getTeamUser(index: Int) -> TeamUser {
        return userIds[index]
    }
}
