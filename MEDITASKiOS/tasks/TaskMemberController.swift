//
//  TaskMemberController.swift
//  MEDITASKiOS
//
//  Created by Andrew Noe on 11/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TaskMemberController: UIViewController {
    
    var teamStore : TeamStore!
    var currentTeam : Team!
    var catchRef: DatabaseReference!
    var catchTaskID: String!
    var teamID: String!
    let currentUId = Auth.auth().currentUser!.uid
    

    @IBOutlet weak var assignedSwitch: UISwitch!
    @IBOutlet var memberView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var memberTableCell: UITableViewCell!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var saveMember: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamStore = TeamStore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamStore.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinTeamTableCell", for: indexPath) as! TeamUserCellView
        let team = teamStore.getTeam(index: indexPath.item)
        cell.textLabel?.text = team.teamName
        cell.dayShift.setOn(team.getTeamUser(index: 0).dayShift, animated: true)
        cell.nightShift.setOn(team.getTeamUser(index: 0).nightShift, animated: true)
        cell.teamId.text = team.teamId
        
        return cell
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        closeThisView();
    }
    
    /*@IBAction func saveAction(_ sender: Any) {
        let cells = self.memberView.visibleCells as! Array<TeamUserCellView>
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
    }*/
    
    func closeThisView() {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
}
