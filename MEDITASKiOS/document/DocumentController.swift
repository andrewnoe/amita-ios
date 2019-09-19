//
//  DocumentController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/4/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase
class DocumentController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    @IBOutlet weak var docsTable: UITableView!
 
    var documentArray = [String]()
    var refDocs: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentTeam.name
        let nib = UINib(nibName: "documentCell", bundle: nil)
        docsTable.register(nib, forCellReuseIdentifier: "eachDocCell")
        
        refDocs = Database.database().reference().child("Documents")
        refDocs.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.documentArray.removeAll()
                
                for docs in snapshot.children.allObjects as![DataSnapshot]{
                    let docObject = docs.value as? [String: AnyObject]
                    let dName = docObject?["dName"]
                    self.documentArray.append(dName as? String ?? "help")
                }
            }
            self.docsTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eachDocCell") as! documentCell
        
        let passName = documentArray[indexPath.row]
        
        cell.customInit(title: passName)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "docsSegue", sender: self)
    }
   
}
extension DocumentController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fileName = url.lastPathComponent
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "newDocumentController") as! newDocumentController
        vc.currfileName = fileName
        vc.currURL = url
        //self.navigationController!.pushViewController(vc, animated: true)
        //vc.navigationController!.pushViewController(vc, animated: true)
      // present(vc, animated: true)
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 33.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        present(nav, animated: true)
        
        
    }
}
