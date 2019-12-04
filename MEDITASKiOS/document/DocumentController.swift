//
//  DocumentController.swift
//  MEDITASKiOS
//
//  Created by Mohammed Raheem on 6/4/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
import Firebase
import QuickLook
class DocumentController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var filteredData: [String]?
    var unfilteredData = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var docsTable: UITableView!
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.searchBar.isHidden = false
    }
    
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }

    let vc: openedDocumentControllerViewController? = openedDocumentControllerViewController()

    //let openedDocController = openedDocumentControllerViewController()
    var documentArray = [String]()
    var refDocs: DatabaseReference!
    var tappedurl = URL(string: "")
    func loadDocData(arr:Array<String>){
        documentArray = arr;
        print(documentArray)
      //  print(docsTable)
        print(docsTable)
        unfilteredData = documentArray
        self.docsTable.reloadData()
        
    }
    
    func getDocData(){
        var getDocArr = [String]()
        let storage = Storage.storage()
        let storageRef = storage.reference().child("docs/")
        storageRef.listAll { (result, error) in
            for item in result.items {
                getDocArr.append(item.name)
            }
            self.loadDocData(arr: getDocArr)
        }
    
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("docView did load")
        super.viewDidLoad()
        self.navigationItem.title = "No Team"
        // Create a reference to the file you want to download
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search "
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = nil
        self.view.setNeedsLayout()
        searchController.searchBar.isHidden = true
        
        var getDocArr = [String]()
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("docs/")
        
        docsTable.delegate = self
        docsTable.dataSource = self
        let nib = UINib(nibName: "documentCell", bundle: nil)
        getDocData()
        docsTable.register(nib, forCellReuseIdentifier: "eachDocCell")
    }
    
    func setURL(url:URL){
        tappedurl = url
        self.vc!.openurl = tappedurl
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
        //self.performSegue(withIdentifier: "docsSegue", sender: self)
        let storage = Storage.storage()
        let storageRef = storage.reference().child("docs/")
        let tapped = (tableView.cellForRow(at: indexPath)! as? documentCell)?.documentTitle.text
        let fileref = storageRef.child(tapped!)
        print(tapped)
        // Fetch the download URL
        fileref.downloadURL { thisurl, error in
            if let error = error {
                print("err")
            } else {
                print(thisurl as! URL)
                self.setURL(url: thisurl!)
                let nav = UINavigationController(rootViewController: self.vc!)
                self.navigationController?.pushViewController(self.vc!, animated: true)
               // self.vc?.viewDidLoad()
            }
        }
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
extension DocumentController: UISearchResultsUpdating {
func updateSearchResults(for searchController: UISearchController) {
    if !searchController.isActive {
        self.navigationItem.searchController = nil
        self.view.setNeedsLayout()
        searchController.searchBar.isHidden = true
        
    }
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
        filteredData = unfilteredData.filter { task in
            return task.lowercased().contains(searchText.lowercased())
            
        }
        
        print(filteredData)
        
    } else {
        filteredData = unfilteredData
        
    }
    documentArray.removeAll()
    for name in filteredData!{
        documentArray.append(name as! String)
        
    }
    // loadTaskData()
    self.docsTable.reloadData()
    }

}
