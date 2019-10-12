//
//  NotifyTableViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/11/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit

class NotifyTableController : UITableViewController {
    //var myarray: [String] = []
    var notifyList: [Notification] = []
    
    override func viewDidLoad() {
        // myarray = ["item1", "item2", "item3"]
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifyTableCell", for: indexPath) 
        cell.textLabel?.text = notifyList[indexPath.item].msg
        return cell
    }
}
