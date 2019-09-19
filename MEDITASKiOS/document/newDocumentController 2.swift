//
//  newDocumentController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 6/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase

import MobileCoreServices
import WebKit

class newDocumentController: UIViewController {
    @IBOutlet weak var displayedFileName: UILabel!
    var currfileName:String = ""
    var currURL = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedFileName?.text = currfileName
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: UIBarButtonItem) {
        //database!!
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        //print(currURL)
        let uploadTask = storageRef.putFile(from: currURL!)
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
    }
}
    
    
    
    @IBAction func previewFile(_ sender: UIButton) {
        let documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.url = currURL
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
        
    }
    
}
extension newDocumentController: UIDocumentInteractionControllerDelegate{
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    
}
