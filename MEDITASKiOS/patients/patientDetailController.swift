//
//  patientEditorController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/21/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

//Controller class for Patient detail view
class patientDetailController: UIViewController{
    
    //Vars for catching data from previous views
    var catchName: String!
    var catchDOB: String!
    var catchEMR: String!
    var catchDesc: String!
    var catchHist: String!
    var catchKey: String!
    var catchStatus: String!
    
 
    //passing the patientcell because I cant figure out how to pass the db ref
    var catchPatient: patientCell!
    
    //Vars for UI elements
    @IBOutlet weak var patientNameView: UITextField!
    @IBOutlet weak var showDOB: UITextField!
    @IBOutlet weak var showEMR: UITextField!
    @IBOutlet weak var showDesc: UITextView!
    @IBOutlet weak var showHistory: UITextView!
    @IBOutlet weak var editButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshGUIText()
        
        let fullNameArr = catchName.components(separatedBy: ",")
        let fullName = fullNameArr[1] + " " + fullNameArr[0]
        self.patientNameView.text = fullName
        self.showDOB.text = catchDOB
        self.showDesc.text = catchDesc
        self.showHistory.text = catchHist
        self.showEMR.text = catchEMR
        var navigationBarAppearace = UINavigationBar.appearance()
        
      
        // Do any additional setup after loading the view.
    }
    
    func refreshGUIText() {
        self.patientNameView.text = catchName
        self.showDOB.text = catchDOB
        self.showEMR.text = catchEMR
        self.showDesc.text = catchDesc
        self.showHistory.text = catchHist
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if (segue.identifier == "patientSegue"){
        
        if(segue.identifier == "toEditView"){
            let toEditView = segue.destination as! patientEditorController
            let fullNameArr = catchName.components(separatedBy: ",")
            toEditView.catchFName = fullNameArr[1]
            toEditView.catchLName = fullNameArr[0]
            toEditView.catchDOB = catchDOB
            toEditView.catchDesc = catchDesc
            toEditView.catchHist = catchHist
            toEditView.catchEMR = catchEMR
            toEditView.catchKey = catchKey
            toEditView.catchStatus = catchStatus
            toEditView.patDetailController = self
        }
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
