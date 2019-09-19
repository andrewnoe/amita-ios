//
//  newTask.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/19/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase
class newTaskController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //this  reference just lets me  connect to the databse that my project is associated with
    var taskType = ""
    var refCreateTask:DatabaseReference?
    var refPatients:DatabaseReference?
    var myButton = UIButton()
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    var priorityPicker: UIPickerView?
    var patientPicker: UIPickerView?
    var selectedField: UITextField!

    //these are all the fields the  user can input  information via keyboard or picker view
    @IBOutlet weak var requiredTitle: UILabel!
    @IBOutlet weak var requiredDate: UILabel!
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputDate: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    @IBOutlet weak var inputPriority: UITextField!
    @IBOutlet weak var inputPatient: UITextField!
    @IBOutlet weak var inputNotify: UISwitch!
    @IBOutlet weak var inputMembers: UITextView!
    @IBOutlet weak var inputDesc: UITextView!
    //let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    var priorities = ["Critical","Urgent","Routine"]
    var listPatients = [String]()
    
    var selectedStatus: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refPatients = Database.database().reference().child("Patient")
        refPatients?.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            self.listPatients.removeAll()
            for t in snapshot.children.allObjects as![DataSnapshot]{
                let patientObject = t.value as? [String: AnyObject]
                var patientID = String()
                var fName = String()
                var lName = String()
                var fullName = String()
                guard let Name = patientObject?["fName"] else { continue }
                if patientObject?["lName"] != nil {
                    lName = "\(patientObject!["lName"] ?? "n/a" as AnyObject)"
                    fullName = (Name as! String) + " " + (lName as! String)
                    self.listPatients.append(fullName)
                }
            }
            
        }
        
        self.title = taskType
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let getTodaysDay = dateFormatter.string(from: todaysDate)
        let getTodaysTime = timeFormatter.string(from: todaysDate)
        let tapAway = UITapGestureRecognizer(target: self, action: #selector(newTaskController.vewTapped(gestureRecognizer: )))
        view.addGestureRecognizer(tapAway)
        inputDate.text = getTodaysDay
        inputTime.text = getTodaysTime
        datePicker = UIDatePicker()
        timePicker = UIDatePicker()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(newTaskController.doneSelector))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePicker?.datePickerMode = .date
        timePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(newTaskController.dateChanged(datePicker:)), for: .valueChanged)
        timePicker?.addTarget(self, action: #selector(newTaskController.timeChanged(timePicker:)), for: .valueChanged)
        inputDate.inputAccessoryView = toolBar
        inputTime.inputAccessoryView = toolBar
        inputDate.inputView = datePicker
        inputTime.inputView = timePicker
        
        priorityPicker = UIPickerView()
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        
        patientPicker = UIPickerView()
        patientPicker?.delegate = self
        patientPicker?.dataSource = self
        
        
        inputPriority.inputAccessoryView = toolBar
        inputPriority.inputView = priorityPicker
        // Do any additional setup after loading the view.
        
        inputPatient.inputAccessoryView = toolBar
        inputPatient.inputView = patientPicker
        
        //referencing the databse  now
        refCreateTask = Database.database().reference()
        switch taskType{
            case "Consent":
                inputNotify.setOn(true, animated: true)
                inputTitle.text = "Consent"
                inputPriority.text = priorities[2]
                break
            case "Prep for Surgery":
                inputNotify.setOn(true, animated: true)
                inputTitle.text = "Prep for Surgery"
                inputPriority.text = priorities[0]
                inputDesc.text = "NPO after midnight\nIVF\nHold blood thinners\nType and Screen"
                break
            case "AM-Labs":
                inputNotify.setOn(true, animated: true)
                inputTitle.text = "AM-Labs"
                inputPriority.text = priorities[2]
                inputDesc.text = "CBC\nBMP\nMag\nPhos"
                break
            case "Post for Surgery":
                inputNotify.setOn(true, animated: true)
                inputTitle.text = "Post for Surgery"
                inputPriority.text = priorities[0]
                inputDesc.text = "*TEMPLATE*\nProcedure: \nDate of Surgery: \nFaculty: \nEquiptment: \n"
                break
            
            default:
                break
            
        }
    }
    
    @objc func vewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func doneSelector(){
        view.endEditing(true)
    }
    @objc func dateChanged( datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        inputDate.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    @objc func timeChanged( timePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        inputTime.text = timeFormatter.string(from: timePicker.date)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == priorityPicker {
            return priorities.count
        }
        if pickerView == patientPicker {
            return listPatients.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == priorityPicker {
            return priorities[row]
        }
        if pickerView == patientPicker {
            return listPatients[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == priorityPicker {
                inputPriority.text = priorities[row]
            }
            if pickerView == patientPicker {
                inputPatient.text = listPatients[row]
            }
            inputPriority.text = priorities[row]
    }
    @IBAction func createTask(_ sender: Any) {
        
        // **  to do ** check for
        let passMe = refCreateTask?.child("Task").childByAutoId()
        
        if(inputTitle.text == "" || inputDate.text == "" || inputPriority.text == ""){
            self.requiredTitle.text = "* required field"
            var alertStr = "Your Task has missing required fields:\n\n"
            if inputTitle.text == ""{
                alertStr += "Title\n"
            }
            if inputDate.text == ""{
                alertStr += "Date\n"
            }
            if inputPriority.text == ""{
                alertStr += "Priority\n"
            }
            
            let alert = UIAlertController(title: "Missing Fields " , message: alertStr, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
        }
        
        let theTeam = currentTeam.name
        passMe?.setValue(["date":inputDate.text!,
                          "notify":"yes",
                          "patientID":inputPatient.text!,
                          "priority":inputPriority.text!,
                          "teamID":currentTeam.id,
                          "taskDescription":inputDesc.text!,
                          "taskID":passMe?.key!,
                          "taskTitle":inputTitle.text!,
                          "teamName":currentTeam.name,
                          "time":inputTime.text!,
                          "taskOwner":myUID,
                          ])
        


//        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true)
 
    }
    
}
