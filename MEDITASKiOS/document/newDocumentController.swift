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
    @IBOutlet weak var UploadButton: UIBarButtonItem!
    
    @IBOutlet weak var CanceButton: UIBarButtonItem!
    @IBOutlet weak var documentStatusLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        documentStatusLabel.text = "Ready to Upload"
        displayedFileName?.text = currfileName
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: UIBarButtonItem) {
        //database!!
        progressView.isHidden = false
        progressView.progress = 0.0
        self.UploadButton.isEnabled = false

        documentStatusLabel.text = "Uploading..."
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let docsRef =  storageRef.child("docs/"+currfileName)
       // let uploadTask = docsRef.putFile(from: currURL!)
        let newMetaData = StorageMetadata()
        
        let uploadTask = docsRef.putFile(from: currURL!, metadata: newMetaData) { (newMetaData:StorageMetadata?, error:Error?) in
            self.documentStatusLabel.text = "Upload Complete"
            self.CanceButton.title = "Done"
        }
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
        uploadTask.observe(.progress, handler: { [weak self](snapshot) in
            guard let progress = snapshot.progress?.fractionCompleted else { return }
            print("\(progress)")
            self?.progressView.progress = Float(progress*100)
        }
        )
        
       
        
}
    
    
    
    @IBAction func previewFile(_ sender: UIButton) {
        let documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.url = currURL
        //print(documentInteractionController.url!.path)
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
