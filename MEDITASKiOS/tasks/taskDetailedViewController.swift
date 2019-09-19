//
//  taskDetailedViewController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/22/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

class taskDetailedViewController: UIViewController {
    
    var editState = 0
    
    var catchTitle: String!
    var catchPriority: String!
    var catchDesc: String!

    var catchPatient: String!
    var catchDate: String!
    var catchTime: String!
    var catchTaskID: String!
    var refTasks: DatabaseReference!
    var refPatients: DatabaseReference!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var showTaskTitle: UILabel!
    @IBOutlet weak var showPatient: UITextField!
    @IBOutlet weak var showAge: UITextField!
    @IBOutlet weak var showDate: UITextField!
    @IBOutlet weak var showPriority: UITextField!
    @IBOutlet weak var showTime: UITextField!
    @IBOutlet weak var showDescription: UITextView!
    
    var priorities = ["Critical","Urgent","Routine"]
    var myPatients = [String]()
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = catchTitle
        navBar.titleView?.tintColor = UIColor.white
        
        self.showTaskTitle.text = catchTitle
        self.showPatient.text = catchPatient
        self.showPatient.isUserInteractionEnabled = false
        self.showPatient.backgroundColor = UIColor.black
        self.showAge.text = "-not found-"
        self.showAge.isUserInteractionEnabled = false
        self.showAge.backgroundColor = UIColor.black
        self.showDate.text = catchDate
        self.showDate.isUserInteractionEnabled = false
        self.showDate.backgroundColor = UIColor.black
        self.showPriority.text = catchPriority
        self.showPriority.isUserInteractionEnabled = false
        self.showPriority.backgroundColor = UIColor.black
        self.showTime.text = catchTime
        self.showTime.isUserInteractionEnabled = false
        self.showTime.backgroundColor = UIColor.black
        self.showDescription.text = catchDesc
        self.showDescription.isUserInteractionEnabled = false
        self.showDescription.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        let alert = UIAlertController(title: "Delete " + catchTitle + "?", message: "Are you sure you want to delete " + catchTitle + "?", preferredStyle: .alert)
        
        let selectDelete = UIAlertAction(title: "Delete", style: .destructive) {
            UIAlertAction in
            
            self.refTasks = Database.database().reference().child("Task")
            self.refTasks.child(self.catchTaskID).removeValue()
            _ = self.navigationController?.popViewController(animated: true)
       
            
            
        }
        
        
        
        alert.addAction(selectDelete)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        _ = navigationController?.popViewController(animated: true)
        return
        
    }
    
    
    @IBAction func editInfo(_ sender: Any) {
        
        if( editState == 0 ){
            let myGre = UIColor(red: 52, green: 52, blue: 52, alpha: 0.4)
            self.showTaskTitle.isUserInteractionEnabled = true
            self.showTaskTitle.backgroundColor = myGre
            
            self.showPatient.isUserInteractionEnabled = true
            self.showPatient.backgroundColor = myGre
            
            self.showAge.isUserInteractionEnabled = true
            self.showAge.backgroundColor = myGre
            
            self.showDate.isUserInteractionEnabled = true
            self.showDate.backgroundColor = myGre
            
            self.showPriority.isUserInteractionEnabled = true
            self.showPriority.backgroundColor = myGre
            
            self.showTime.isUserInteractionEnabled = true
            self.showTime.backgroundColor = myGre
            
            self.showDescription.backgroundColor = myGre
            self.showDescription.isUserInteractionEnabled = true
        
            //self.navBar.rightBarButtonItem?.title = "Save"
            
            self.editState = 1
            return
        }
        if( editState == 1 ){
            self.showTaskTitle.text = showTaskTitle.text
            self.showTaskTitle.isUserInteractionEnabled = false
            self.showTaskTitle.backgroundColor = UIColor.black
            self.showPatient.text = showPatient.text
            self.showPatient.isUserInteractionEnabled = false
            self.showPatient.backgroundColor = UIColor.black
            self.showAge.text = "-not found-"
            self.showAge.isUserInteractionEnabled = false
            self.showAge.backgroundColor = UIColor.black
            self.showDate.text = "-not found-"
            self.showDate.isUserInteractionEnabled = false
            self.showDate.backgroundColor = UIColor.black
            self.showPriority.text = showPriority.text
            self.showPriority.isUserInteractionEnabled = false
            self.showPriority.backgroundColor = UIColor.black
            self.showTime.text = showTime.text
            self.showTime.isUserInteractionEnabled = false
            self.showTime.backgroundColor = UIColor.black
            self.showDescription.text = showDescription.text
            self.showDescription.isUserInteractionEnabled = false
            self.showDescription.backgroundColor = UIColor.black
            
            
            self.editState = 0
            
            //broken line needs to update
           
            
            
            self.refTasks = Database.database().reference().child("Task")
    
            let grabTest = self.refTasks.child(self.catchTaskID).description()
            print(grabTest)
            refTasks?.child(catchTaskID).updateChildValues(["date":catchDate,
                                                            "taskTitle":showTaskTitle.text!,
                                                            "priority":catchPriority,
                                                            "taskDescription":showDescription.text!,
                                                            "patientID":showPatient.text!,
                                                            "time":showTime.text!,
                                                            "taskID":catchTaskID]
            )
            
           
            
            return
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
