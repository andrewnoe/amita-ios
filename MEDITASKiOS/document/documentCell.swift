//
//  documentCell.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/9/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class documentCell: UITableViewCell {

    @IBOutlet weak var documentTitle: UILabel!
    @IBOutlet weak var imagePic: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customInit(title: String){
        self.documentTitle.text = title
        self.imagePic.image = UIImage(named: "docIcon.png")
        
    }
}
