//
//  ChatGateway.swift
//  MEDITASKiOS
//
//  Created by Mark Robinson on 9/27/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import Foundation
import Firebase

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
    
    func getMessages(count: Int, completion: @escaping ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        
        // TODO: grab messages from firebase for the given task
        let refChat = Database.database().reference().child("Chats")
        
        refChat.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for t in snapshot.children.allObjects as![DataSnapshot]{
                let chatObject = t.value as? [String: AnyObject]
                
                if let chatMsg = chatObject?["chat_msg"] as? String {
                    
                    //print(chatMsg)

                    // this should be id from firebase
                    let uniqueID = UUID().uuidString
                    // this is user info from firebase message
                    let user = SampleData.shared.senders.random()!
                    // this is timestamp from firebase
                    let date = SampleData.shared.dateAddingRandomTime()
                    // this is message from firebase
                    let message = MockMessage(text: chatMsg, user: user, messageId: uniqueID, date: date)
                    
                    print(message)
                    
                    messages.append(message)

                }
                
            }
            
            completion(messages)

        }
 
        /*
         for _ in 0..<count {
         let uniqueID = UUID().uuidString
         let user = senders.random()!
         let date = dateAddingRandomTime()
         let randomSentence = Lorem.sentence()
         let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)

            print(message)

            messages.append(message)
         }
*/
        
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
