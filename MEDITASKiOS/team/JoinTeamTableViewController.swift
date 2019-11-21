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
    
    override func viewDidLoad() {
        myarray = ["item1", "item2", "item3"]
        
        //joinTeamTable.beginUpdates()
        //joinTeamTable.insertRowsAtIndexPaths([
        //    NSIndexPath(forRow: myarray.count-1, inSection: 0)], withRowAnimation: .Automatic)
        //joinTeamTable.endUpdates()
    }
    
}
