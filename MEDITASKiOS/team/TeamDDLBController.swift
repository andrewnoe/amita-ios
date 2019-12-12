//
//  teamDDLBController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 12/12/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class TeamDDLBController: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var teamStore = TeamStore()
    var taskEditController : taskEditViewController!
    
    override init() {
        taskEditController = nil
    }

    init(data: TeamStore) {
        super.init()
        self.teamStore = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamStore.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamDDLBCell", for: indexPath)
        let team = teamStore.getTeam(index: indexPath.row)

        cell.textLabel?.text = team.teamName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = teamStore.getTeam(index: indexPath.row)
        
        taskEditController.selectTeam(team: team)
    }
}
