//
//  newPatientController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/25/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

//Controller for adding new patient View
class newPatientController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var referenceDB:DatabaseReference?
    
    //Vars for UI elements
    private var datePicker: UIDatePicker?
    @IBOutlet weak var inputfName: UITextField!
    @IBOutlet weak var inputLname: UITextField!
    @IBOutlet weak var inputDOB: UITextField!
    @IBOutlet weak var inputEMR: UITextField!
    @IBOutlet weak var inputDesc: UITextView!
    @IBOutlet weak var inputMedic: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputfName.delegate = self
        self.inputLname.delegate = self
        self.inputDOB.delegate = self
        self.inputEMR.delegate = self
        self.inputDesc.delegate = self
        self.inputMedic.delegate = self
        
        let tapAway = UITapGestureRecognizer(target: self, action: #selector(newTaskController.viewTapped(gestureRecognizer: )))
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
        datePicker?.addTarget(self, action: #selector(newPatientController.dateChanged(datePicker:)), for: .valueChanged)
        inputDOB.inputAccessoryView = toolBar
        inputDOB.inputView = datePicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
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
        
        inputDOB.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func saveToDB(_ sender: Any) {
        referenceDB = Database.database().reference()
        print("reached")
        let passfName = inputfName.text!
        let passlName = inputLname.text!
        let passDOB = inputDOB.text!
        let passEMR = inputEMR.text!
        let passDesc = inputDesc.text!
        let passMedic = inputMedic.text!
        
        let postToDB = referenceDB?.child("Patient").childByAutoId()
        postToDB?.setValue([
            "fName":passfName,
            "lName":passlName,
            "dob":passDOB,
            "emr":passEMR,
            "description":passDesc,
            "healthHistory":passMedic,
            "locked": false,
            "mInitial": "",
            "notes": "",
            "patientID":postToDB?.key!,
            "provider": ""])
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
