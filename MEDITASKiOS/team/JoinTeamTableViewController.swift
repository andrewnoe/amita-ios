//
//  JoinTeamTableViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/20/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class JoinTeamTableViewController : UITableViewController {
    var teamStore : TeamStore!
    
    let refTeam = Database.database().reference().child("Team")
    let currentUId = Auth.auth().currentUser!.uid
    
    // need this outlet because we have to programmatically reload the table
    // after the firebase fetch (it is asynchronously fetching)
    @IBOutlet var teamTableView: UITableView!
    
    override func viewDidLoad() {
        teamStore = TeamStore()
        fetchTeams()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamStore.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinTeamTableCell", for: indexPath) as! TeamUserCellView
        let team = teamStore.getTeam(index: indexPath.item)
        //cell.textLabel?.text = team.teamName
        cell.teamName.text = team.teamName
        if team.userIds.count > 0 {
            cell.dayShift.setOn(team.getTeamUser(index: 0).dayShift, animated: true)
            cell.nightShift.setOn(team.getTeamUser(index: 0).nightShift, animated: true)
        } else {
            cell.dayShift.setOn(false, animated: true)
            cell.nightShift.setOn(false, animated: true)
        }
        cell.teamId.text = team.teamId
        
        return cell
    }
    
    func fetchTeams() {
        let queryTeam = self.refTeam.queryOrdered(byChild: "teamName")
        queryTeam.observe(DataEventType.value, with: { (snapshot) in
            self.teamStore.removeAll()
            for team in snapshot.children.allObjects as! [DataSnapshot] {
                guard let teamInfo = team.value as? [String: Any]
                    else {
                        return
                }
                let teamName = teamInfo["teamName"] as? String
                let team = Team(teamId: team.key, teamName: teamName!)
                
                // iterate over the userIDs to determine if we are included as a member
                if let userDict = teamInfo["userIDs"] as? [String:AnyObject] {
                    var inTeam = false
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
                    if(!inTeam) {
                        // add me to team but set day, night, and filter to false
                        self.refTeam.child(team.teamId).child("userIDs").child(self.currentUId).setValue(["filter_on": false, "day_shift": false, "night_shift": false])
                        
                        let teamUser = TeamUser(userId: self.currentUId
                            , dayShift: false
                            , nightShift: false
                            , filterOn: false)
                        team.addTeamUser(teamUser: teamUser)
                    }
                }
                
                self.teamStore.addTeam(team: team)
            }
            // as soon as we are done fetching, tell the table to refresh
            self.teamTableView.reloadData()
        })
    }

    @IBAction func cancelAction(_ sender: Any) {
        closeThisView();
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let cells = self.teamTableView.visibleCells as! Array<TeamUserCellView>
        for cell in cells {
            let teamId = cell.teamId.text
            let dayShift = cell.dayShift.isOn
            let nightShift = cell.nightShift.isOn
            
            var fieldName = "\(teamId ?? "0")/userIDs/\(currentUId)/day_shift"
            self.refTeam.child(fieldName).setValue(dayShift)

            fieldName = "\(teamId  ?? "0")/userIDs/\(currentUId)/night_shift"
            self.refTeam.child(fieldName).setValue(nightShift)

        }
        closeThisView();
    }
    
    func closeThisView() {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
}
