//
//  CreateTaskChooserController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 8/6/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class CreateTaskChooserController: UIViewController {
    var thisTaskType = ""
    @IBAction func emptyTask(_ sender: Any) {
        thisTaskType = "Empty Task"
        loadNextView()
 
    }
    
    @IBAction func consentTask(_ sender: Any) {
        thisTaskType = "Consent"
        loadNextView()

    }
    
    @IBAction func prepForSurgery(_ sender: Any) {
        thisTaskType = "Prep for Surgery"
        loadNextView()

    }
    @IBAction func amLabs(_ sender: Any) {
        thisTaskType = "AM-Labs"
        loadNextView()

    }
    
    @IBAction func postForSurgery(_ sender: Any) {
        thisTaskType = "Post for Surgery"
        loadNextView()
    }
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func loadNextView(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "newTaskController") as! newTaskController
        //self.navigationController!.pushViewController(vc, animated: true)
        //vc.navigationController!.pushViewController(vc, animated: true)
        // present(vc, animated: true)
        vc.taskType = thisTaskType
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: true)
        }
        //present(vc, animated: true)
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
