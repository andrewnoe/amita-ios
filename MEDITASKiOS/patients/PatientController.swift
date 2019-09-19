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
    var refPatients: DatabaseReference!
    var passName: String!
    var passEmr: String!
    var passDOB: String!
    var passDesc: String!
    var passHistory: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = currentTeam.name
        let nib = UINib(nibName: "patientCell", bundle: nil)
        patientTable.register(nib, forCellReuseIdentifier: "eachPatientCell")
        
        refPatients = Database.database().reference().child("Patient")
        refPatients.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.samplePatients.removeAll()
                self.sampleDOB.removeAll()
                self.sampleDesc.removeAll()
                self.sampleHistory.removeAll()
                self.samplePatID.removeAll()
                self.sampleEMR.removeAll()
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
                    
                    let mix = lName + ", " + (fName as! String)
                    
                    self.samplePatients.append(mix)
                    self.sampleDOB.append(getDOB)
                    self.sampleDesc.append(getDesc)
                    self.sampleEMR.append(getEMR)
                    self.sampleHistory.append(getHist)
                }
            }
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
        
        let passHist = sampleHistory[indexPath.row]
        cell.customInit(title: passName, dobVal: passInfo,patientID: passID, description: passDescirp, history: passHist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellPath = patientTable.indexPathForSelectedRow
        let selectedCell = patientTable.cellForRow(at: cellPath!)! as! patientCell
        passName = selectedCell.patientTitle.text
        passDOB = selectedCell.patientDOB.text
        passDesc = selectedCell.patientDesc
        passEmr = selectedCell.patientID
        
        passHistory = selectedCell.patientHistory
        self.performSegue(withIdentifier: "patientSegue", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "patientSegue"){
            let toDocView = segue.destination as! patientEditorController
            toDocView.catchName = passName
            toDocView.catchDOB = passDOB
            toDocView.catchDesc = passDesc
            toDocView.catchHist = passHistory
            toDocView.catchEMR = passEmr
        }
    }
    @IBAction func newPatient(_ sender: Any) {
        self.performSegue(withIdentifier: "newPatient", sender: self)
        
    }
    
}
