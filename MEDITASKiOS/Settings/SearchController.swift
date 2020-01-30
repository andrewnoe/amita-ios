//
//  SearchController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 7/25/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

//Controller for Search bar
class SearchController: UIViewController {
    //@IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBar.placeholder = "yeet"
        let searchController = UISearchController(searchResultsController: nil)
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = true
        // 3
        searchController.searchBar.placeholder = "Search "
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        
    }
    
    @IBAction func didCancel(_ sender: Any) {
        dismiss(animated: true)
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
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
