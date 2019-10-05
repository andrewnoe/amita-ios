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
    
    let dateFormatterFromFB = DateFormatter()
    
    let dispatchGroup = DispatchGroup()

    let system = MockUser(senderId: "000000", displayName: "System")
    let nathan = MockUser(senderId: "000001", displayName: "Nathan Tannar")
    let steven = MockUser(senderId: "000002", displayName: "Steven Deutsch")
    let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")
    
    lazy var senders = [nathan, steven, wu]
    var now = Date()

    private init() {
        dateFormatterFromFB.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func getMessages(count: Int, completion: @escaping ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        
        // TODO: grab messages from firebase for the given task
        let refChat = Database.database().reference().child("Chats")
        let refUsers = Database.database().reference().child("User")
        
        refChat.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            var counter = 0
            
            for t in snapshot.children.allObjects as![DataSnapshot] {
        
                print("ENTERED")
                //self.dispatchGroup.enter()

                let chatObject = t.value as? [String: AnyObject]
                
                let senderId = chatObject!["sender_id"] as! String
                
                print("*** \(senderId)")
                
                let querySender = refUsers.queryOrderedByKey().queryEqual(toValue: senderId)
                querySender.observe(.value, with: { (senderSnapshot) in
                    

                    for childSnapshot in senderSnapshot.children.allObjects as? [DataSnapshot] ?? [] {
                        guard let dictionary = childSnapshot.value as? [String: Any]
                            else {
                                print("*** CRAP")
                                return
                                
                        }
                        //user.name =
                    
                    // for childSnapshot in senderSnapshot.children {
                    //for childSnapshot in senderSnapshot.children.allObjects as![DataSnapshot] {
                        
                        //let senderObject = childSnapshot.value as? [String: String]
                        var firstName = dictionary["fName"] as? String
                        var lastName = dictionary["lName"] as? String
/*
                        if senderObject?["fName"] != nil {
                            firstName = senderObject!["fName"]!
                        }
                        if senderObject?["lName"] != nil {
                            lastName = senderObject!["lName"]!
                        }
                         Snap (genetigner_art@gmail_com) {
                         admin = 0;
                         email = "genetigner.art@gmail.com";
                         fName = Gene;
                         lName = Tigner;
                         }
*/
                       // print(childSnapshot.value)
                        //print("\(chatObject?["chat_msg"])")
                        
                        if let chatMsg = chatObject?["chat_msg"] as? String {
                            // this should be id from firebase
                            let id = chatObject!["id"] as! String
                            
                            // this is user info from firebase message
                            let userName =  firstName! + " " + lastName!
                            let user = MockUser(senderId: "000000", displayName: userName)
                            //let user = SampleData.shared.senders.random()!
                            
                            // this is timestamp from firebase
                            let added = self.dateFormatterFromFB.date(from: chatObject?["added"] as! String)
                            //SampleData.shared.dateAddingRandomTime()
                            // this is message from firebase
                            let message = MockMessage(text: chatMsg, user: user, messageId: id, date: added!)
                    
                            print(message)
                            
                            messages.append(message)

                            counter = counter + 1
                            
                            if (counter == snapshot.childrenCount) {
                                completion(messages)
                            }
                        }

                    }
                    // print("LEFT 2")
                    //self.dispatchGroup.leave()

                })
        

            }
            /*
            self.dispatchGroup.notify(queue: .main) {
                print("COMPLETED")
                completion(messages)
            }
 */

        }
        
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
