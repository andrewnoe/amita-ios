/*
MIT License

Copyright (c) 2017-2019 MessageKit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    var taskId:String = ""
    var messageList: [MockMessage] = []
    
    let refChat = Database.database().reference().child("Chats")
    let refUsers = Database.database().reference().child("User")

    var currentUser = MockUser(senderId: Auth.auth().currentUser!.uid, displayName: "")

    let dateFormatterFromFB = DateFormatter()

    let refreshControl = UIRefreshControl()
    
    var displayedMessages : [String:MockMessage] = [:]
    var senderMap : [String:MockUser] = [:]

    let dispatchGroup = DispatchGroup()
    
    let formatter = ChatGateway.shared.dateFormatterFromFB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterFromFB.dateFormat = "yyyy-MM-dd HH:mm:ss"

        configureMessageCollectionView()
        configureMessageInputBar()
        title = "Chat for " + self.taskId
        
        dispatchGroup.enter()
        fetchSenderInfo()
        // wait until fetchSenderInfo calls dispatchGroup.leave to finish loading
        dispatchGroup.notify(queue: .main, execute: {
            self.loadFirstMessages()
            self.currentUser = self.senderMap[Auth.auth().currentUser!.uid]!
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
            .onNewMessage { [weak self] message in
                self?.insertMessage(message)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MockSocket.shared.disconnect()
        audioController.stopAnyOngoingPlaying()
    }
    
    /*
     grab all user info and store it in senderMap
     synchronized function so leave dispatch group when done
    */
    func fetchSenderInfo() {
        var counter = 0
        let querySender = self.refUsers.queryOrdered(byChild: "uid")
        querySender.observeSingleEvent(of: .value, with: { (sendersSnapshot) in
            for senderSnapshot in sendersSnapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let senderInfo = senderSnapshot.value as? [String: Any]
                    else {
                        self.dispatchGroup.leave()
                        return
                }
                let firstName = senderInfo["fName"] as? String
                let lastName = senderInfo["lName"] as? String
                let user = MockUser(senderId: senderInfo["uid"] as! String, displayName: firstName! + " " + lastName!)
                self.senderMap[user.senderId] = user

                counter = counter + 1
                if (counter == sendersSnapshot.childrenCount) {
                    self.dispatchGroup.leave()
                }
            }
        })
        
    }
    
    func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let queryChat = self.refChat.child(self.taskId).queryOrdered(byChild: "added")
            queryChat.observe(DataEventType.value, with: { (snapshot) in
                var counter = 0
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    if let val = self.displayedMessages[item.key] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                    } else {
                    
                        let chatInfo = item.value as? [String:AnyObject]
                        let chatId = item.key
                        let chatMsg:String = chatInfo?["chat_msg"] as! String
                        
                        let addDate = Date(timeIntervalSince1970: chatInfo?["added"] as! Double / 1000)
                        let added = self.dateFormatterFromFB.string(from: addDate)
                        let senderUid = chatInfo!["sender_uid"] as! String
                    
                        let user = self.senderMap[senderUid]
                        var message = MockMessage(text: chatMsg, user: user!, messageId: chatId, date: addDate)

                        self.insertMessage(message)

                        counter = counter + 1
                        if (counter == snapshot.childrenCount) {
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom()
                        }
                    }
                }
            })

        }
    }
    
    @objc
    func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        
        displayedMessages[message.messageId] = message
        
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return currentUser;
        //return SampleData.shared.currentSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        var newMessageMap: [String:Any] = [:]
        
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            // sleep(1)
            for component in components {
                if let str = component as? String {
                    guard let newKey = self.refChat.child(self.taskId).childByAutoId().key else { return }
                    newMessageMap = ["sender_uid": self.currentUser.senderId,
                                     "id" : newKey,
                        "chat_msg": str,
                        "added": [".sv": "timestamp"]] as [String : Any]
                    let childUpdates = ["/\(self.taskId)/\(newKey)": newMessageMap]
                    self.refChat.updateChildValues(childUpdates)
                }
            }
 
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components, messageMap: newMessageMap)
                //self?.loadFirstMessages()
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any], messageMap:[String:Any]) {
        for component in data {
            let user = self.currentUser //SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: messageMap["id"] as! String, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}
