//
//  patientCell.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/9/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class patientCell: UITableViewCell
{

    @IBOutlet weak var patientTitle: UILabel!
    @IBOutlet weak var patientDOB: UILabel!
    var patientDesc: String!
    var patientHistory: String!
    var patientID: String!
    @IBOutlet weak var viewCell: UIView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customInit(title: String, dobVal: String, patientID: String, description: String, history: String)
    {
        self.patientTitle.text = title
        self.patientDOB.text = dobVal
        self.patientDesc = description
        self.patientHistory = history
        self.patientID = patientID
    }
    
}
