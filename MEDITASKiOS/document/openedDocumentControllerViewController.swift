//
//  openedDocumentControllerViewController.swift
//  MEDITASKiOS
//
//  Created by Samuel Carey on 9/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import WebKit

//Controller for opened document Screen
class openedDocumentControllerViewController: UIViewController, WKUIDelegate{
    var webView: WKWebView!
    var openurl = URL(string: "")
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.viewDidLoad()
        // let myURL = URL(openurl)
        let myRequest = URLRequest(url: openurl!)
        webView.load(myRequest)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            webView.stopLoading()
            webView.removeFromSuperview()
        }
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
