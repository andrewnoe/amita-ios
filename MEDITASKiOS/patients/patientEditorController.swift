//
//  patientEditorController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/21/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

/*-----patientEditorController-----
 *
 * This controller manages the Patient Editor view
 *
 *@param(kinda) var catch_____ - a variable that recieves data from the Patient Detail Controller
 *
 */
class patientEditorController: UIViewController, UITextFieldDelegate{
    
    var ref: DatabaseReference?
    private var datePicker: UIDatePicker?
    var catchFName: String!
    var catchLName: String!
    var catchDOB: String!
    var catchDesc: String!
    var catchHist: String!
    var catchEMR: String!
    var catchKey: String!
    var catchStatus: String!
    var patDetailController: patientDetailController!
    
    
    
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var emrField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var healthField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var statusField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fNameField.text = catchFName!
        self.lNameField.text = catchLName!
        self.dobField.text = catchDOB!
        self.emrField.text = catchEMR!
        self.descField.text = catchDesc!
        self.healthField.text = catchHist!
        self.statusField.text = catchStatus!
        self.fNameField.delegate = self
        self.lNameField.delegate = self
        self.dobField.delegate = self
        self.emrField.delegate = self
        self.descField.delegate = self
        self.healthField.delegate = self
        self.statusField.delegate = self
        
        //let tapAway = UITapGestureRecognizer(target: self, action: #selector(patientEditorController.keyboardWillHide(notification:)))
        //view.addGestureRecognizer(tapAway)
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
        dobField.inputAccessoryView = toolBar
        dobField.inputView = datePicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        
        
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
        
        dobField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    /*-----saveToDB-----
     *
     * This function takes the text in the textFields at the time of the button press
     * and updates the respective fields in the database.
     *
     */
    @IBAction func saveToDB(_ sender: Any) {
        let passfName = fNameField.text!
        let passlName = lNameField.text!
        let passDOB = dobField.text!
        let passEMR = emrField.text!
        let passDesc = descField.text!
        let passMedic = healthField.text!
        let passStatus = statusField.text!
        
        print(passfName + " " + passlName + " " + passDOB + " " + passEMR + " " + passDesc + " " +
            passMedic + " " + catchKey)
        
        self.ref = Database.database().reference().child("Patient").child(catchKey)
        
        let postToDB = ref?.childByAutoId()
        let dataToDB = [
            "fName":passfName,
            "lName":passlName,
            "dob":passDOB,
            "emr":passEMR,
            "description":passDesc,
            "healthHistory":passMedic,
            "locked": false,
            "mInitial": "",
            "notes": "",
            "patientID":postToDB?.key! as Any,
            "provider": "",
            "status":passStatus]
        
        print("Made it to catch block")
        print(patDetailController)
        patDetailController.catchName = passfName + " " + passlName
        patDetailController.catchDOB = passDOB
        patDetailController.catchDesc = passDesc
        patDetailController.catchHist = passMedic
        patDetailController.catchEMR = passEMR
        patDetailController.catchKey = catchKey
        patDetailController.refreshGUIText()
        
        ref?.updateChildValues(dataToDB)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*-----prepare-----
     *
     * This prepare function sends the potentially updated data back
     * to the detail view.
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("IS THIS BEING CALLLED?")
        let toDetailView = segue.destination as! patientDetailController
       
        toDetailView.catchName = fNameField.text! + " " + lNameField.text!
        toDetailView.catchDOB = dobField.text!
        toDetailView.catchDesc = descField.text!
        toDetailView.catchHist = healthField.text!
        toDetailView.catchEMR = emrField.text!
        toDetailView.catchKey = catchKey
        
        
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
