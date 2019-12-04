//
//  taskEditViewController.swift
//  MEDITASKiOS
//
//  Created by Andrew Noe on 10/22/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

class taskEditViewController: UIViewController {
    
    var ref: DatabaseReference?
    private var datePicker: UIDatePicker?
    var catchTitle: String!
    var catchDate: String!
    var catchTime: String!
    var catchDesc: String!
    var catchTaskID: String!
    var catchUrgency: String!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var timeField: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleField.text = catchTitle
        self.dateField.text = catchDate
        self.timeField.text = catchTime
        self.descField.text = catchDesc
        self.priorityField.text = catchUrgency
        
        let tapAway = UITapGestureRecognizer(target: self, action: #selector(patientEditorController.keyboardWillHide(notification:)))
        view.addGestureRecognizer(tapAway)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker = UIDatePicker()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(newPatientController.doneSelector))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(patientEditorController.dateChanged(datePicker:)), for: .valueChanged)
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func doneSelector(){
        view.endEditing(true)
    }
    @objc func dateChanged( datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dateField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func saveToDB(sender: UIBarButtonItem) {
        let passTitle = titleField.text!
        let passDate = dateField.text!
        let passTime = timeField.text!
        let passDesc = descField.text!
        let passPriority = priorityField.text!
        self.ref = Database.database().reference().child("Task")
        
        ref?.child(catchTaskID).updateChildValues(["taskTitle":passTitle,
                                                        "date":passDate,
                                                        "time":passTime,
                                                        "taskDescription":passDesc,
                                                        "priority":passPriority])
        
        print("***END DB FUNC***")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDetailView = segue.destination as! taskDetailedViewController
        
        toDetailView.catchTitle = catchTitle
        toDetailView.catchDate = catchDate
        toDetailView.catchDesc = catchDesc
        toDetailView.catchTime = catchTime
        toDetailView.catchPriority = catchUrgency
    }
    
    /*@objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }*/

}
