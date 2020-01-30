//
//  taskEditViewController.swift
//  MEDITASKiOS
//
//  Created by Andrew Noe on 10/22/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

//Controller Class of the Task Editor screen
class taskEditViewController: UIViewController {
    
    var ref: DatabaseReference?
    private var datePicker: UIDatePicker?
    
    //These vars catch data from the previous screen
    var catchTitle: String!
    var catchDate: String!
    var catchTime: String!
    var catchDesc: String!
    var catchTaskID: String!
    var catchUrgency: String!
    var catchTeamName: String!
    var catchTeamId: String!
    var selectedTeamId: String!
    
    var myTeams: TeamStore!
    let refTeam = Database.database().reference().child("Team")
    let currentUId = Auth.auth().currentUser!.uid
    var teamDDLBController = TeamDDLBController()
    var isShowingTeamList: Bool!
    var taskDetailController: taskDetailedViewController!
    
    //These vars are outlets for on-screen UI elements
    @IBOutlet weak var selectTeamButton: UIButton!
    @IBOutlet weak var selectTeamList: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //Function calls when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTeams = TeamStore()
        teamDDLBController.teamStore = myTeams
        teamDDLBController.taskEditController = self
        selectTeamList.dataSource = teamDDLBController
        selectTeamList.delegate = teamDDLBController
        isShowingTeamList = false
        selectTeamList.isHidden = true
        
        self.titleField.text = catchTitle
        self.dateField.text = catchDate
        self.timeField.text = catchTime
        self.descField.text = catchDesc
        self.priorityField.text = catchUrgency
        
        selectTeamButton.setTitle(catchTeamName, for: .normal)
        selectedTeamId = catchTeamId

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
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        getTeamDict()

    }
    
    //Function calls on selecting the team changing drop down
    @IBAction func onSelectTeam(_ sender: Any) {
        if isShowingTeamList {
            selectTeamList.isHidden = true
            isShowingTeamList = false
        } else {
            //selectTeamList.hid
            selectTeamList.isHidden = false
            isShowingTeamList = true
            
        }
    }
    
    func selectTeam(team : Team) {
        selectTeamButton.setTitle(team.teamName, for: .normal)
        selectedTeamId = team.teamId
        selectTeamList.isHidden = true
        isShowingTeamList = false
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
    
    //Function calls when save is pressed; updates data on DB
    @IBAction func saveToDB(_ sender: Any) {
        let passTitle = titleField.text!
        let passDate = dateField.text!
        let passTime = timeField.text!
        let passDesc = descField.text!
        let passPriority = priorityField.text!
        let passTeamId = selectedTeamId
        let passTeamName = selectTeamButton.title(for: .normal)
        
        self.ref = Database.database().reference().child("Task")
        
        ref?.child(catchTaskID).updateChildValues(["taskTitle":passTitle,
                                                   "date":passDate,
                                                   "time":passTime,
                                                   "taskDescription":passDesc,
                                                   "priority":passPriority,
                                                   "teamID":passTeamId!,
                                                   "teamName":passTeamName!])
        
        taskDetailController.catchTitle = passTitle
        taskDetailController.catchDate = passDate
        taskDetailController.catchDesc = passDesc
        taskDetailController.catchTime = passTime
        taskDetailController.catchPriority = passPriority
        taskDetailController.catchTeamId = selectedTeamId
        taskDetailController.catchTeamName = selectTeamButton.title(for: .normal)
        taskDetailController.refreshGUIText()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //Function loads dictionary of all teams
    func getTeamDict() {
        let queryTeam = self.refTeam.queryOrdered(byChild: "teamName")
        queryTeam.observe(DataEventType.value, with: { (snapshot) in
            self.myTeams.removeAll()
            for team in snapshot.children.allObjects as! [DataSnapshot] {
                guard let teamInfo = team.value as? [String: Any]
                    else {
                        return
                }
                let teamName = teamInfo["teamName"] as? String
                let team = Team(teamId: team.key, teamName: teamName!)
                
                // iterate over the userIDs to determine if we are included as a member
                if let userDict = teamInfo["userIDs"] as? [String:AnyObject] {
                    var inTeam = false
                    for (userId, teamOptions) in userDict {
                        if(userId == self.currentUId) {
                            if let optionsDict = teamOptions as? [String:Bool] {
                                if optionsDict["day_shift"]! || optionsDict["night_shift"]! {
                                    inTeam = true
                                    let teamUser = TeamUser(userId: userId
                                        , dayShift: optionsDict["day_shift"]!
                                        , nightShift: optionsDict["night_shift"]!
                                        , filterOn: optionsDict["filter_on"]!)
                                    team.addTeamUser(teamUser: teamUser)
                                }
                            }
                        }
                    }
                    if(inTeam) {
                        self.myTeams.addTeam(team: team)
                    }
                }
            }
            self.selectTeamList.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("*** is this being called?")
        
        let toDetailView = segue.destination as! taskDetailedViewController
        
        toDetailView.catchTitle = catchTitle
        toDetailView.catchDate = catchDate
        toDetailView.catchDesc = catchDesc
        toDetailView.catchTime = catchTime
        toDetailView.catchPriority = catchUrgency
        toDetailView.catchTeamId = selectedTeamId
        toDetailView.catchTeamName = selectTeamButton.title(for: .normal)
        
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
