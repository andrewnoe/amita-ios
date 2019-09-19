//
//  taskCell.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/9/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class taskCell: UITableViewCell{

    @IBOutlet weak var tielCell: UILabel!
    @IBOutlet weak var viewCell: UIView!
    var myPriority: String!
    var myDesc: String!
    @IBOutlet weak var patientName: UILabel!
    var myDate: String!
    @IBOutlet weak var timeCell: UILabel!
    var myTaskID: String!
    @IBOutlet weak var roomNum: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customInit(title: String, priority: String, description: String,  patient: String, date: String, timeText: String, taskID: String, roomIn: String){
        self.tielCell.text = title
        self.patientName.text = patient
        self.myPriority = priority
        self.myDesc = description
        self.myDate = date
        self.timeCell.text = timeText
        self.myTaskID = taskID
        self.roomNum.text = roomIn
        // var priorities = ["Critical","Semi-Critical","Routine"]
        if(priority == "Critical"){
            imageCell.image = UIImage(named: "new_critical_RED.png")
        }
        if(priority == "Urgent"){
            imageCell.image = UIImage(named: "new_critical_ORANGE.png")
        }
        if(priority == "Routine"){
            imageCell.image = UIImage(named: "notStartedIcon.png")
        }
        
    }
    //self.performSegue(withIdentifier: "taskSegue", sender: self)
}
