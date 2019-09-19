//
//  MenuViewControllerTableViewController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 7/24/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit
enum MenuType: Int{
    case teams
    case logout
    case home
}

class MenuViewController: UITableViewController {
     var didTapMenuType: ((MenuType) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
    
}
