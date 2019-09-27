//
//  ChatGateway.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 9/27/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation

final internal class ChatGateway {
    static let shared = ChatGateway()
    
    let system = MockUser(senderId: "000000", displayName: "System")
    let nathan = MockUser(senderId: "000001", displayName: "Nathan Tannar")
    let steven = MockUser(senderId: "000002", displayName: "Steven Deutsch")
    let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")
    
    lazy var senders = [nathan, steven, wu]
    var now = Date()

    private init() {
        
    }
    
    func getMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            // this should be id from firebase
            let uniqueID = UUID().uuidString
            // this is user info from firebase message
            let user = senders.random()!
            // this is timestamp from firebase
            let date = dateAddingRandomTime()
            // this is message from firebase
            let msgText = "Hello world!"
            let message = MockMessage(text: msgText, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
 
    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
}
