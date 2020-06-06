//
//  MessageListView.swift
//  CCMesseage
//
//  Created by student on 2020/6/5.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import MessengerKit

class MessageListView: MSGMessengerViewController {
    let steve = RoomUser(displayName: "Steve", avatar: UIImage(named: "test"), avatarUrl: nil, isSender: true)
    let tim = RoomUser(displayName: "Tim",avatar: UIImage(named: "test"), avatarUrl: nil, isSender: false)
    
    lazy var messages: [[MSGMessage]] = {
        return [
            [
                MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: tim, sentAt: Date()),
            ],
            [
                MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: steve, sentAt: Date()),
                MSGMessage(id: 3, body: .text("Okay ready when you are"), user: steve, sentAt: Date())
            ]
        ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        dataSource = self
        delegate   = self
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
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
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
    }
    
    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }
    
    func shouldOpen(url: URL) -> Bool {
        return true
    }
    
}
