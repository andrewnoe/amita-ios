//
//  patientEditorController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/21/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class patientEditorController: UIViewController {
    var catchName: String!
    var catchDOB: String!
    var catchDesc: String!
    var catchHist: String!
    var catchEMR: String!
    @IBOutlet weak var patientNameView: UITextField!
    @IBOutlet weak var showDOB: UITextField!
    @IBOutlet weak var showEMR: UITextField!
    @IBOutlet weak var showDesc: UITextView!
    @IBOutlet weak var showHistory: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patientNameView.text = catchName
        self.showDOB.text = catchDOB
        self.showDesc.text = catchDesc
        self.showHistory.text = catchHist
        self.showEMR.text = catchEMR
        var navigationBarAppearace = UINavigationBar.appearance()
        
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
