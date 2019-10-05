//
//  Constants.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 9/24/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("Chats")
    }
}
