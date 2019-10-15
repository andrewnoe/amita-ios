//
//  NotifyViewController.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 10/10/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import UIKit

class NotifyViewController: UINavigationController  {
    //var notifyList: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("*** \(notifyList.count)")
        self.setEditing(true, animated: true)
    }
}
