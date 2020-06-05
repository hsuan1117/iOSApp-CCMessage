//
//  MessageListView.swift
//  CCMesseage
//
//  Created by student on 2020/6/5.
//  Copyright © 2020 hsuan. All rights reserved.
//

import UIKit
import MessengerKit

var messages : [Message] = []
class MessageListView: MSGMessengerViewController {
    
    let steve = RoomUser(displayName: "Steve", avatar: #imageLiteral(resourceName: "steve228uk"), avatarUrl: nil, isSender: true)
    
    let tim = RoomUser(displayName: "Tim", avatar: #imageLiteral(resourceName: "timi"), avatarUrl: nil, isSender: false)
    
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
        dataSource = self
    }
}

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
