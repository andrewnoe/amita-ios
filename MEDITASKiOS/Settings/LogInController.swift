//
//  LogInController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/4/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LogInController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var Icon: UIImageView!
    @IBOutlet var LogInBar: UIView!
    @IBOutlet var EmailLogIn: UITextField!
    @IBOutlet var PasswordLogIn: UITextField!
    @IBOutlet var ButtonLogIn: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet var EntireView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailLogIn.autocorrectionType = .no
        EmailLogIn.layer.cornerRadius = EmailLogIn.frame.size.height/2
        EmailLogIn.clipsToBounds = true
        PasswordLogIn.autocorrectionType = .no
        PasswordLogIn.layer.cornerRadius = EmailLogIn.frame.size.height/2
        PasswordLogIn.clipsToBounds = true
        //ref.child
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let versiontext = "Beta "
        version.text = versiontext + appVersion!
        let tapAway = UITapGestureRecognizer(target: self, action: #selector(LogInController.vewTapped(gestureRecognizer: )))
        view.addGestureRecognizer(tapAway)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func vewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    //this just hides the keyboard
    let translateBoxed = CGAffineTransform(translationX: 0, y: 200)
    
    override func viewDidAppear(_ animated: Bool) {
        //session is saved in USER
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "mainSegue", sender: self)
        }
        
    }

    @IBAction func verifyLogin(_ sender: Any) {
        guard let email = EmailLogIn.text else {return}
        guard let password = PasswordLogIn.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                self.message.text = "logIn successfull"
                
                self.performSegue(withIdentifier: "mainSegue", sender: self)
            } else {
                
                self.errorLabel.text = error?.localizedDescription
                print(error.self)
            }
        }
    }
    

}
