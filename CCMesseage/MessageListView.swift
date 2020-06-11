//
//  MessageListView.swift
//  CCMesseage
//
//  Created by student on 2020/6/5.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import MessengerKit
import Firebase

class MessageListView: MSGMessengerViewController {
    let db = Firestore.firestore()
    var roomID : String = ""
    var roomName : String = ""
    var participant : Array<String> = []
    var msgID       : Dictionary<Int,String>    = [:]
    var uids        : Dictionary<String,String> = [:]
    let steve = RoomUser(displayName: "Steve", avatar: UIImage(named: "test"), avatarUrl: nil, isSender: true)
    let tim = RoomUser(displayName: "Tim",avatar: UIImage(named: "test"), avatarUrl: nil, isSender: false)
    var MM = MessageManager()
    lazy var messages: [[MSGMessage]] = {
        return []
    }()
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView){
        MM.addMessage(id: roomID, message: inputView.message)
    }
    private func getMessages(id : String) {
        
        db.collection("rooms")
          .document(id)
          .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            for msg in (data["messages"] as! Array<String>) {
                let ref = self.db.collection("messages").document(msg)
                self.messages = []
                ref.getDocument{ (doc,error) in
                    print(msg)
                    if doc == nil {
                        return
                    }
                    let __ = Int(Date().unixTimestamp)
                    self.msgID[__] = msg
                    self.messages.append(
                        [MSGMessage(
                            id: __,
                            body: .text("\(doc?["content"] as! String)"),
                            user: RoomUser(displayName: self.uids[doc?["sender"] as! String]!, avatar: UIImage(named: "test"), avatarUrl: nil, isSender: (doc?["sender"] as! String == Auth.auth().currentUser?.uid ? true : false)),
                            sentAt: Date(unixTimestamp: doc?["timestamp"] as! Double)
                        )]
                    )
                    
                    self.collectionView.reloadData()
                    
                    self.collectionView.scrollToBottom(animated: true)
                    self.collectionView.layoutTypingLabelIfNeeded()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = roomName
        //MM.addMessage(id: roomID, message: "Hi")
        getMessages(id: roomID)
        dataSource = self
        delegate   = self
        for user in participant {
            db.collection("users").document(user).getDocument(completion: {
                (doc,error) in
                self.uids[user] = doc!["name"] as! String
            })
        }
    }
    override func insert(_ message: MSGMessage) {
            
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                
            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
        
    }

    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {
        
        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)
                    
                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                    
                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: false)
            self.collectionView.layoutTypingLabelIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                callback?()
            }
        })
        
    }
}

// MARK: - MSGDataSource

extension MessageListView: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        messages.sort(by: {
            (m1,m2) in
            if(m1[0].sentAt < m2[0].sentAt){
                return true
            }else{
                return false
            }
        })
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return messages[section][0].sentAt.timeString()
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }

}

// MARK: - MSGDelegate

extension MessageListView: MSGDelegate {
    
    func linkTapped(url: URL) {
        print("Link tapped:", url)
    }
    
    func avatarTapped(for user: MSGUser) {
        print("Avatar tapped:", user)
    }
    
    func tapReceived(for message: MSGMessage) {
        print("Tapped: ", message)
        
    }
    
    func longPressReceieved(for message: MSGMessage) {
        print("Long press:", message)
        let deleteConfirm = UIAlertController(title: "刪除訊息？", message: "您確定要刪除此訊息嗎？", preferredStyle: .alert)

        deleteConfirm.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.MM.deleteMessage(id: self.msgID[message.id]!, roomID: self.roomID, completion: {
                self.showAlert(title: "OK", message: "刪除完成")
                self.collectionView.reloadData()
            })
        }))

        deleteConfirm.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))

        present(deleteConfirm, animated: true, completion: nil)
    }
    
    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }
    
    func shouldOpen(url: URL) -> Bool {
        return true
    }
    
}
