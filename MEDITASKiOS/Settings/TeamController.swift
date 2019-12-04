//
//  TeamController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 8/1/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

class TeamController: UIViewController {
    @IBOutlet weak var team1Button: UIButton!
    @IBOutlet weak var team2Button: UIButton!
    var refTasks: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        if myTeams.count < 2{
            team1Button.setTitle(myTeams[0].name, for: .normal)
            team2Button.setTitle("NO TEAM", for: .normal)
        } else {
            team1Button.setTitle(myTeams[0].name, for: .normal)
            team2Button.setTitle(myTeams[1].name, for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func changeto1(_ sender: Any) {
        currentTeam = myTeams[0]
        
    }
    @IBAction func changeto2(_ sender: Any) {
        currentTeam = myTeams[1]
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
