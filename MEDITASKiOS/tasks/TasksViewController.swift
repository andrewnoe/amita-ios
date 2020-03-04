//
//  TasksViewController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 5/30/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

/*
struct team{
    var id: String
    var name: String
    var userIDs = [String]()
}
var myTeams = [team]()
var myUID = ""
var currentTeam = team(id: "", name: "", userIDs: [])
 */
var myUID = ""

/*
 this structure is for each cell
 is active will expand the tab on true
 section title is the title for each group
 section data, time, name is just its data
 
 
 */
struct accordionCells{
    var isActive = Bool()
    var accordianName = String()
    var sectionDate = [String]()
    var sectionMembers = [String]()
    var sectionNotify = [String]()
    var sectionPatient = [String]()
    var sectionPriority = [String]()
    var sectionDesc = [String]()
    var sectionTaskID = [String]()
    var sectionTaskTitle = [String]()
    var sectionTeamName = [String]()
    var sectionTime = [String]()
    var sectionTeamId = [String]()
    
}

//Controller Class for the Task list view
class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var refTasks: DatabaseReference!
    // var refTeams: DatabaseReference!

    var teamStore : TeamStore!
    var currentTeam : Team!
    let refTeam = Database.database().reference().child("Team")
    let currentUId = Auth.auth().currentUser!.uid

    //Vars for UI elements
    @IBOutlet weak var tableTasks: UITableView!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var taskTab: UISegmentedControl!
    let transition = SlideInTransition()
    var topView: UIView?
    @IBOutlet weak var tableTasksHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var sectionTeamname = String()
    //this is the current task, the important stuff
    var todaysTaskTitles = [String]()
    var todaysPriorities = [String]()
    var todaysDescs = [String]()
    var todaysTeam = String()
    var todaysTeamId = String()
    var todaysPatients = [String]()
    var todaysDates = [String]()
    var todaysTimes = [String]()
    var todaysTaskIDs = [String]()
    var todaysNotify = [String]()
    var todaysMembers = [String]()
    //these are furture variables with more appropiate names
    var retrieveTasks = [String]()
    var retrievePriority  = [String]()
    var retrievePatient = [String]()
    var myTasks = false
    // ----  SAMPLE DATA END  ---- //
    
    var isSearching = false
    var countMany = 0
    var filteredData: [String]?
    var unfilteredData = [String]()
    
    //Vars for passing data to the next view
    var passTaskName : String!
    var passPriority : String!
    var passTaskDesc : String!
    var passTeamName : String!
    var passTeamId : String!
    var passPatientID : String!
    var passDate : String!
    var passTime : String!
    var passTaskID : String!
    var passNotify : String!
    
    var tableViewData = [accordionCells]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // 3/3/2020 CHANGE THIS FOR DISAPPEARING HAMBURGER
    var menuShowing = false
    var menuViewController : MenuViewController!;
    
    //Function for when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamStore = TeamStore()

        // tableTasks.delegate = self
        // tableTasks.dataSource = self
        myUID = (Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "_"))!
        getTeamDict()
       
        //loadTaskData()
        let userID = (Auth.auth().currentUser!.email)!.replacingOccurrences(of: ".", with: "_")
       
      
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search "
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
        self.navigationItem.searchController = nil
        self.view.setNeedsLayout()
        searchController.searchBar.isHidden = true

    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.searchBar.isHidden = false
    }
    
    func getTeamDict(){
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
            self.loadTaskData()
        })
    }
    
    //Function for loading Task data into the scrollable list
    func loadTaskData() {
        //if (currentTeam.name == ""){
        //currentTeam = myTeams[0]
        //}
        currentTeam = teamStore.getTeam(index: 0)
        //self.navigationItem.title = currentTeam.teamName
        
        // --- Get Date ---  //
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "LLLL-dd"
        let todaysDate = format.string(from: date)
        
        tableViewData = [accordionCells(isActive: true, accordianName: "All Tasks", sectionDate: [todaysDate], sectionMembers: todaysMembers, sectionNotify: todaysNotify, sectionPatient: todaysPatients, sectionPriority: todaysPriorities, sectionDesc: todaysDescs, sectionTaskID: todaysTaskIDs, sectionTaskTitle: todaysTaskTitles, sectionTeamName: [todaysTeam], sectionTime: todaysTimes, sectionTeamId: [todaysTeamId])]
        
        let nib = UINib(nibName: "taskCell", bundle: nil)
        let nib2 = UINib(nibName: "taskCellSelect", bundle: nil)
        tableTasks.register(nib, forCellReuseIdentifier: "eachTaskCell")
        tableTasks.register(nib2, forCellReuseIdentifier: "eachCellSelect")
        
        //here i am referencing the database and looking for  anything under the child "Task" directly in root
        refTasks = Database.database().reference().child("Task")
        
        //now it stores?? it in snapshot
        refTasks.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                //clearing every list, this is when we  requery everything it  doesnt dupplicate, and if we delete something itll be gone instead of 2 while loops with an if we just reset this!
                self.tableViewData[0].sectionTaskTitle.removeAll()
                self.tableViewData[0].sectionTime.removeAll()
                self.tableViewData[0].sectionPatient.removeAll()
                self.tableViewData[0].sectionPriority.removeAll()
                self.tableViewData[0].sectionDesc.removeAll()
                self.tableViewData[0].sectionDate.removeAll()
                self.tableViewData[0].sectionTime.removeAll()
                self.tableViewData[0].sectionTaskID.removeAll()
                self.tableViewData[0].sectionNotify.removeAll()
                self.tableViewData[0].sectionTeamName.removeAll()
                self.tableViewData[0].sectionTeamId.removeAll()
                for tasks in snapshot.children.allObjects as![DataSnapshot]{
                    let taskObject = tasks.value as? [String: AnyObject]
                    var priority = String()
                    var taskDesc = String()
                    var teamName = String()
                    var teamId = String()
                    var patientID =  String()
                    var date = String()
                    var taskMembers = String()
                    var time = String()
                    var taskID = String()
                    var notify = String()
                    /*var taskName = String()
                     
                     if taskObject?["taskName"] != nil {
                     taskName = taskObject?["taskName"] as! String
                     } else {
                     taskName = "Unnamed task"
                     }
                     
                     */
                    
                    //snapshot is the item
                    
                    //we need atleast a task name, so if the task name doesnt exist  IGNORE  IT
                    //considering deleting it if it doesnt have a task name
                    guard let taskName = taskObject?["taskTitle"] else { continue }
                    
                    if taskObject?["date"] != nil {
                        date = "\(taskObject!["date"] ?? "date not given" as AnyObject)"
                    } else {
                        date = "date not given"
                    }
                    
                    if taskObject?["taskMembers"] != nil {
                        taskMembers = "\(taskObject!["member"] ?? "members not given" as AnyObject)"
                    } else {
                        taskMembers = "-missing-"
                    }
                    
                    if taskObject?["notify"] != nil {
                        notify = "\(taskObject!["notify"] ?? "notify not given" as AnyObject)"
                    } else {
                        notify = "n/a"
                    }
                    
                    if taskObject?["patientID"] != nil {
                        patientID = "\(taskObject!["patientID"] ?? "patientID not given" as AnyObject)"
                    } else {
                        patientID = "patientID not given"
                    }
                    
                    if taskObject?["priority"] != nil {
                        priority = "\(taskObject!["priority"] ?? "n/a" as AnyObject)"
                    } else {
                        priority = "n/a"
                    }
                    
                    
                    if taskObject?["taskDescription"] != nil {
                        taskDesc = taskObject?["taskDescription"] as! String
                    } else {
                        taskDesc = "no description"
                    }
                    
                    if taskObject?["taskID"] != nil {
                        taskID = "\(taskObject!["taskID"] ?? "taskID not given" as AnyObject)"
                    } else {
                        taskID = "taskID not given"
                    }
                    var isTeamTask = false
                    for team in self.teamStore.teams {
                        if (taskObject?["teamID"] as? String == team.teamId) {
                            // its a task for me only if I am on AM or PM shift
                            for teamUser in team.userIds {
                                if teamUser.dayShift || teamUser.nightShift {
                                    isTeamTask = true
                                }
                            }
                        }
                    }
                    if !isTeamTask {
                        continue
                    }
                    
                    if taskObject?["taskMembers"] != nil {
                        
                        if (self.myTasks == false){
                            if let UIDDict = taskObject?["taskMembers"] as? NSDictionary{
                                let UIDArray = Array(UIDDict.allKeys as! [String])
                                
                                if UIDArray.contains(myUID) != true{
                                    if taskObject?["taskOwner"] as! String != myUID{
                                        continue
                                    }
                                }
                            } else {
                                if myUID != taskObject?["taskMembers"] as! String{
                                    if taskObject?["taskOwner"] as! String != myUID{
                                        continue
                                    }
                                }
                            }
                            
                            
                            
                        } else {
                        }
                    }
                    
                    
                    
                    if taskObject?["teamName"] != nil {
                        teamName = taskObject!["teamName"] as! String
                    } else {
                        teamName = "teamName not given"
                    }
                    if taskObject?["teamID"] != nil {
                        teamId = taskObject!["teamID"] as! String
                    } else {
                        teamId = ""
                    }

                    if taskObject?["time"] != nil {
                        time = "\(taskObject!["time"] ?? "time not given" as AnyObject)"
                    } else {
                        time = "time not given"
                    }
                    
                    
                    
                    //here i am adding the values to the first expanding tab
                    self.tableViewData[0].sectionTaskTitle.append(taskName as! String )
                    self.tableViewData[0].sectionPatient.append(patientID)
                    self.tableViewData[0].sectionPriority.append(priority)
                    self.tableViewData[0].sectionDesc.append(taskDesc)
                    self.tableViewData[0].sectionDate.append(date)
                    self.tableViewData[0].sectionTime.append(time)
                    self.tableViewData[0].sectionTaskID.append(taskID)
                    self.tableViewData[0].sectionNotify.append(notify)
                    self.tableViewData[0].sectionTeamName.append(teamName)
                    self.tableViewData[0].sectionTeamId.append(teamId)
                }
                
            }
            
            self.unfilteredData = self.tableViewData[0].sectionTaskTitle
            self.tableTasks.reloadData()
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isActive == true{
            return tableViewData[section].sectionTaskTitle.count + 1
        }else{
            return  1
        }
        
    }
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
   
    
    @IBAction func didTapMenu(_ sender: Any) {
            if(menuShowing) {
                menuViewController.dismiss(animated: true, completion: nil)
                menuShowing = false;
            } else {
                menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
                menuViewController.didTapMenuType = { menuType in
                    self.transitionToNew(menuType)
                }
                menuViewController.modalPresentationStyle = .overCurrentContext
                menuViewController.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
                present(menuViewController, animated: true)
                menuShowing = true;
            }
    }
    
    @IBAction func taskSeperator(_ sender: Any) {
        switch taskTab.selectedSegmentIndex
        {
        case 0:
            self.myTasks = false
            loadTaskData()
        case 1:
            self.myTasks = true
            loadTaskData()
        default:
            break
        }
    }
    func transitionToNew(_ menuType: MenuType) {
   
        switch menuType {
        case .teams:
            break
        case .logout:
            try! Auth.auth().signOut()
            exit(0)
            break
        default:
            break

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eachCellSelect") as! taskCellSelect
            
            let passTitle = tableViewData[indexPath.section].accordianName
            cell.customInit(title: passTitle)
            //self.tableTasks?.rowHeight = 44
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "eachTaskCell") as! taskCell
            
            let initTitle = tableViewData[indexPath.section].sectionTaskTitle[indexPath.row  - 1]
            let initPatient = tableViewData[indexPath.section].sectionPatient[indexPath.row - 1]
            let initPriority = tableViewData[indexPath.section].sectionPriority[indexPath.row - 1]
            let initDesc = tableViewData[indexPath.section].sectionDesc[indexPath.row - 1]
            let initDate = tableViewData[indexPath.section].sectionDate[indexPath.row - 1]
            let initTime = tableViewData[indexPath.section].sectionTime[indexPath.row - 1]
            let initTaskID = tableViewData[indexPath.section].sectionTaskID[indexPath.row - 1]
            let initNotify = tableViewData[indexPath.section].sectionNotify[indexPath.row - 1]
            let teamId = tableViewData[indexPath.section].sectionTeamId[indexPath.row - 1]
            let teamName = tableViewData[indexPath.section].sectionTeamName[indexPath.row - 1]
            
            cell.customInit(title: initTitle, priority: initPriority, description: initDesc,  patient: initPatient, date: initDate, timeText: initTime, taskID: initTaskID, roomIn: initNotify )
            cell.teamId.text = teamId
            cell.teamName.text = teamName
            //self.tableTasks?.rowHeight = 69
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].isActive == true {
                tableViewData[indexPath.section].isActive = false
                let selected = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(selected, with: .none)
            }else{
                tableViewData[indexPath.section].isActive = true
                let selected = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(selected, with: .none)
            }
            
        }
        else if indexPath.row != 0{
            let cellPath = tableTasks.indexPathForSelectedRow
            let selectedCell =  tableTasks.cellForRow(at: cellPath!)! as! taskCell
            passTaskName = selectedCell.tielCell.text
            passPriority = selectedCell.myPriority
            passTaskDesc = selectedCell.myDesc

            passPatientID = selectedCell.patientName.text
            passDate = selectedCell.myDate
            passTime = selectedCell.timeCell.text
            passTaskID = selectedCell.myTaskID
            passNotify = selectedCell.roomNum.text
            passTeamName = selectedCell.teamName.text
            passTeamId = selectedCell.teamId.text
            self.performSegue(withIdentifier: "taskSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Function for sending data and changing screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "taskSegue"){
            let toTaskView = segue.destination as! taskDetailedViewController
            toTaskView.catchTitle = passTaskName
            toTaskView.catchTime = passTime
            toTaskView.catchPriority = passPriority
            toTaskView.catchDesc = passTaskDesc
            toTaskView.catchPatient = passPatientID
            toTaskView.catchDate  = passDate
            toTaskView.catchTime = passTime
            toTaskView.catchTaskID = passTaskID
            toTaskView.catchTeamId = passTeamId
            toTaskView.catchTeamName = passTeamName
        }
        
        if (segue.identifier == "memberSegue"){
            let toTaskView = segue.destination as! TaskMemberController
            toTaskView.catchTaskID = passTaskID
            //toTaskView.catchTeamID = passTeamID
            
        }
        
    }
    
 }
extension TasksViewController: UIViewControllerTransitioningDelegate, UISearchResultsUpdating {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
}
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            self.navigationItem.searchController = nil
            self.view.setNeedsLayout()
            searchController.searchBar.isHidden = true
           
        }
            isSearching = true
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                filteredData = unfilteredData.filter { task in
                    return task.lowercased().contains(searchText.lowercased())
                  
                }
                
                print(filteredData)
                
            } else {
                filteredData = unfilteredData

            }
        self.tableViewData[0].sectionTaskTitle.removeAll()
        for name in filteredData!{
            self.tableViewData[0].sectionTaskTitle.append(name as! String)
        
        }
           // loadTaskData()
            self.tableTasks.reloadData()
    }
    
    
    
    
    

}
