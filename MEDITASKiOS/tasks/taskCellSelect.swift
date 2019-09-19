//
//  taskCellSelect.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/15/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class taskCellSelect: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customInit(title: String){
        self.cellTitle.text = title
    }
    
}
