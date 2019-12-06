//
//  PatientController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 5/31/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase
class PatientController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var patientTable: UITableView!
    let  cellTitle =  "Cell  Title"
    //CellTitle will change "Hello Patients"
    var samplePatients = [String]()
    var sampleDOB = [String]()
    var sampleDesc = [String]()
    var sampleHistory = [String]()
    var samplePatID = [String]()
    var sampleEMR = [String]()
    var sampleKey = [String]()
    var sampleStatus = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData: [String]?
    var unfilteredData = [String]()
    
  
    @IBAction func didTapSearch(_ sender: Any) {
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.searchBar.isHidden = false
    }
    
    var passName: String!
    var passEmr: String!
    var passDOB: String!
    var passDesc: String!
    var passHistory: String!
    var passKey: String!
    var passStatus: String!

    let refPatients = Database.database().reference().child("Patient")

    let currentUId = Auth.auth().currentUser!.uid
    let refTeam = Database.database().reference().child("Team")
    var teamStore : TeamStore!
    let refTask = Database.database().reference().child("Task")
    var taskStore : TaskStore!
    var myPatients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamStore = TeamStore()
        taskStore = TaskStore()
        
        self.navigationItem.title = "No Team"
        let nib = UINib(nibName: "patientCell", bundle: nil)
        patientTable.register(nib, forCellReuseIdentifier: "eachPatientCell")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search "
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = nil
        self.view.setNeedsLayout()
        searchController.searchBar.isHidden = true

        // get and observe my teams
        getTeamDict()

    }
    
    func getPatientDict() {
        refPatients.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.samplePatients.removeAll()
                self.sampleDOB.removeAll()
                self.sampleDesc.removeAll()
                self.sampleHistory.removeAll()
                self.samplePatID.removeAll()
                self.sampleEMR.removeAll()
                self.sampleKey.removeAll()
                self.sampleStatus.removeAll()
                
                for patients in snapshot.children.allObjects as![DataSnapshot]{
                    /*
                     let patientObject = patients.value as? [String: AnyObject]
                     let lName = patientObject?["lName"] as! String
                     let fName = patientObject?["fName"] as! String
                     let getDOB = patientObject?["DOB"] as! String
                     */
                    let patientObject = patients.value as? [String: AnyObject]
                    var lName = String()
                    var getDOB = String()
                    var getDesc = String()
                    var getHist = String()
                    var getEMR = String()
                    var getKey = String()
                    var getStatus = String()
                    guard let fName = patientObject?["fName"] else{ continue }
                    
                    if patientObject?["lName"] != nil{
                        lName = "\(patientObject!["lName"] ?? "n/a" as AnyObject)"
                    } else {
                        lName = "n/a"
                    }
                    
                    if patientObject?["dob"] != nil{
                        getDOB = "\(patientObject!["dob"] ?? "n/a" as AnyObject)"
                    } else {
                        getDOB = "n/a"
                    }
                    
                    if patientObject?["description"] != nil{
                        getDesc = "\(patientObject!["description"] ?? "n/a" as AnyObject)"
                    } else {
                        getDesc = "n/a"
                    }
                    if patientObject?["healthHistory"] != nil{
                        getHist = "\(patientObject!["healthHistory"] ?? "n/a" as AnyObject)"
                    } else {
                        getHist = "n/a"
                    }
                    if patientObject?["emr"] != nil{
                        getEMR = "\(patientObject!["emr"] ?? "n/a" as AnyObject)"
                    } else {
                        getEMR = "n/a"
                    }
                    if patientObject?["key"] != nil{
                        getKey = patients.key
                    } else {
                        getKey = patients.key
                    }
                    if patientObject?["status"] != nil{
                        getStatus = "\(patientObject!["status"] ?? "n/a" as AnyObject)"
                    } else {
                        getStatus = "Unknown"
                    }
                    
                    
                    let mix = lName + ", " + (fName as! String)
                    
                    // iterate over our teams to determine if this is our task
                    for myPatientId in self.myPatients {
                        
                        //print("\(myPatientId) : \(getKey)")
                        
                        if myPatientId == getKey {
                            
                            self.samplePatients.append(mix)
                            self.sampleDOB.append(getDOB)
                            self.sampleDesc.append(getDesc)
                            self.sampleEMR.append(getEMR)
                            self.sampleHistory.append(getHist)
                            self.sampleKey.append(getKey)
                            self.sampleStatus.append(getStatus)
                        }
                    }
                }
            }
            self.unfilteredData = self.samplePatients
            
            self.patientTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samplePatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eachPatientCell") as! patientCell
        self.patientTable?.rowHeight = 80
        let passName = samplePatients[indexPath.row]
        let passInfo = sampleDOB[indexPath.row]
        let passDescirp = sampleDesc[indexPath.row]
        let passID = sampleEMR[indexPath.row]
        let passKey = sampleKey[indexPath.row]
        let passStatus = sampleStatus[indexPath.row]
        let passHist = sampleHistory[indexPath.row]
        
        cell.customInit(title: passName, dobVal: passInfo,patientID: passID, description: passDescirp, history: passHist, key: passKey, status: passStatus)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellPath = patientTable.indexPathForSelectedRow
        let selectedCell = patientTable.cellForRow(at: cellPath!)! as! patientCell
        passName = selectedCell.patientTitle.text
        passDOB = selectedCell.patientDOB.text
        passDesc = selectedCell.patientDesc
        passEmr = selectedCell.patientID
        passKey = selectedCell.patientKey
        passStatus = selectedCell.patientStatus
        
        passHistory = selectedCell.patientHistory
        self.performSegue(withIdentifier: "patientSegue", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "patientSegue"){
            let toDocView = segue.destination as! patientDetailController
            toDocView.catchName = passName
            toDocView.catchDOB = passDOB
            toDocView.catchDesc = passDesc
            toDocView.catchHist = passHistory
            toDocView.catchEMR = passEmr
            toDocView.catchKey = passKey
            toDocView.catchStatus = passStatus
        }
    }
    @IBAction func newPatient(_ sender: Any) {
        self.performSegue(withIdentifier: "newPatient", sender: self)
        
    }
    
    func getTeamDict() {
        let queryTeam = self.refTeam.queryOrdered(byChild: "teamName")
        queryTeam.observe(DataEventType.value, with: { (snapshot) in
            self.teamStore.removeAll()
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
                            inTeam = true
                            if let optionsDict = teamOptions as? [String:Bool] {
                                let teamUser = TeamUser(userId: userId
                                    , dayShift: optionsDict["day_shift"]!
                                    , nightShift: optionsDict["night_shift"]!
                                    , filterOn: optionsDict["filter_on"]!)
                                team.addTeamUser(teamUser: teamUser)
                            }
                        }
                    }
                    if(!inTeam) {
                        // add me to team but set day, night, and filter to false
                        self.refTeam.child(team.teamId).child("userIDs").child(self.currentUId).setValue(["filter_on": false, "day_shift": false, "night_shift": false])
                        
                        let teamUser = TeamUser(userId: self.currentUId
                            , dayShift: false
                            , nightShift: false
                            , filterOn: false)
                        team.addTeamUser(teamUser: teamUser)
                    }
                }
                
                
                self.teamStore.addTeam(team: team)
            }
            // as soon as we are done fetching, tell the table to refresh
            //self.loadTaskData()
            
            // get and observe my tasks
            self.getTaskDict()

        })
    }

    func getTaskDict() {
        let queryTask = self.refTask.queryOrdered(byChild: "taskDescription")
        queryTask.observe(DataEventType.value, with: { (snapshot) in
            self.taskStore.removeAll()
            self.myPatients.removeAll()
            for task in snapshot.children.allObjects as! [DataSnapshot] {
                guard let taskInfo = task.value as? [String: Any]
                    else {
                        return
                }
               //print("\(taskInfo)")
                
                let teamId = taskInfo["teamID"] as? String
                let patientId = taskInfo["patientID"] as? String
                
                // iterate over our teams to determine if this is our task
                for team in self.teamStore.teams {
                    //print("\(task.key) : \(teamId)")
                    let task = Task(taskId: task.key, teamId: teamId!)
                    if teamId == team.teamId {
                        self.taskStore.addTask(task: task)
                        self.myPatients.append(patientId!)
                    }
                }
            }
            // as soon as we are done fetching, tell the table to refresh
            //self.loadTaskData()

            // get and observe patients that belong to my tasks
            self.getPatientDict()

        })
    }
}
extension PatientController:  UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            self.navigationItem.searchController = nil
            self.view.setNeedsLayout()
            searchController.searchBar.isHidden = true
            
        }
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredData = unfilteredData.filter { patient in
                return patient.lowercased().contains(searchText.lowercased())
                
            }
            
            //print(filteredData)
            
        } else {
            filteredData = unfilteredData
            
        }
        self.samplePatients.removeAll()
        for name in filteredData!{
            self.samplePatients.append(name as! String)
            
        }
        self.patientTable.reloadData()
    }
}

