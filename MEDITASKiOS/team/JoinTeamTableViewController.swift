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
    
    var myarray: [String] = []
    
    let currentUId = Auth.auth().currentUser!.uid
    
    @IBAction func cancelAction(_ sender: Any) {
        closeThisView();
    }
    
    @IBAction func saveAction(_ sender: Any) {
        closeThisView();
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("yo 0 /myarray.count");
        
        return myarray.count;
    }
    
    func closeThisView() {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinTeamTableCell", for: indexPath)
        
        //let notification = notificationStore.getNotification(index: indexPath.item)
        print("yo 1");
        
        print("/myarray[indexPath.item]");
        
        cell.textLabel?.text = myarray[indexPath.item];
        //cell.notificationId = notification.notifyId
        //cell.notificationLabel.text = notifyList[indexPath.item].msg
        return cell
    }
    
    override func viewDidLoad() {
        myarray = ["Team 1", "Team 2", "Team 3"];
        
        //joinTeamTable.beginUpdates()
        //joinTeamTable.insertRowsAtIndexPaths([
        //    NSIndexPath(forRow: myarray.count-1, inSection: 0)], withRowAnimation: .Automatic)
        //joinTeamTable.endUpdates()
    }
    
}
