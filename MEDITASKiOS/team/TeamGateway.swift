//
//  TeamGateway.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 12/12/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import Firebase

final internal class TeamGateway {
    static let shared = TeamGateway()
    
    let refTeam = Database.database().reference().child("Team")
    let currentUId = Auth.auth().currentUser!.uid

    func getMyTeams(dispatchGroup:DispatchGroup) -> TeamStore {
        let teamStore = TeamStore()
        
        let queryTeam = self.refTeam.queryOrdered(byChild: "teamName")
        queryTeam.observe(DataEventType.value, with: { (snapshot) in
            for team in snapshot.children.allObjects as! [DataSnapshot] {
                guard let teamInfo = team.value as? [String: Any]
                    else {
                        return
                }
                let teamName = teamInfo["teamName"] as? String
                let team = Team(teamId: team.key, teamName: teamName!)
                
                // iterate over the userIDs to determine if we are included as a member
                var inTeam = false
                if let userDict = teamInfo["userIDs"] as? [String:AnyObject] {
                    for (userId, teamOptions) in userDict {
                        if(userId == self.currentUId) {
                            inTeam = true
                            if let optionsDict = teamOptions as? [String:Bool] {
                                let teamUser = TeamUser(userId: userId
                                    , dayShift: optionsDict["day_shift"]!
                                    , nightShift: optionsDict["night_shift"]!
                                    , filterOn: optionsDict["filter_on"]!)
                                team.addTeamUser(teamUser: teamUser)
                            }
                        }
                    }
                }
                
                if(inTeam) {
                    print("found team \(team)")
                    teamStore.addTeam(team: team)
                }
            }
        })
        dispatchGroup.leave()
        return teamStore
    }
    
}
