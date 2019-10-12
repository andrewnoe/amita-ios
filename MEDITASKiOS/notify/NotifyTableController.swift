//
//  NotifyTableViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/11/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit

class NotifyTableController : UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    override func viewDidLoad() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) 
        cell.textLabel?.text = "test"
        return cell
    }
    
    
}
