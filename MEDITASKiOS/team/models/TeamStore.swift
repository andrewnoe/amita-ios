//
//  TeamStore.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

class TeamStore {
    var teams = [Team]() //list of all teams
    
    init() {
    }
    
    func removeAll() {
        teams.removeAll()
    }
    
    func addTeam(team:Team) {
        teams.append(team)
    }
    
    func getCount() -> Int {
        return teams.count
    }
    
    func getTeam(index : Int) -> Team {
        return teams[index]
    }
    
    func removeTeam(_ team: Team) {
        // delete from the model
        if let index = teams.index(of: team) {
            teams.remove(at: index)
        }
    }
        
}
