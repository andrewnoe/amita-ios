//
//  JoinTeamViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 11/20/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit

class JoinTeamViewController: UITableViewController  {
    //var notifyList: [Notification] = []
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBAction func closeAction(_ sender: Any) {
        //print("*** CLOSE PRESSED ***");
        
        // save our choices
        
        // close this dialog
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("*** \(notifyList.count)")
        // self.setEditing(true, animated: true)
        
        // fetch all teams from db
        
        // modify with user selected or not
    }
}
