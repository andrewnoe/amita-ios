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

//Controller Class for the Task Member screen: Not quite sure whats all going on
class TaskMemberController: UIViewController {
    
    var teamStore : TeamStore!
    var currentTeam : Team!
    var catchRef: DatabaseReference!
    var catchTaskID: String!
    var teamID: String!
    var memberTableCell: TaskMemberCellView!
    
    let members = ["Gene", "Andrew", "Jamie", "Sam"]
    let currentUId = Auth.auth().currentUser!.uid
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var memberView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveMember: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamStore = TeamStore()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = members[indexPath.row]
        
        return cell
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
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
