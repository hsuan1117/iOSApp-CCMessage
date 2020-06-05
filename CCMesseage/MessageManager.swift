//
//  MessageManager.swift
//  CCMesseage
//
//  Created by student on 2020/5/29.
//  Copyright © 2020 hsuan. All rights reserved.
//

import Foundation
import Firebase
import MessengerKit

struct Message {
    var title   : String
    var author  : String
    var url     : String
}

struct Room {
    var name    : String
    var id      : String
}

struct RoomUser : MSGUser {
    var displayName: String
    var avatar: UIImage?
    var avatarUrl: URL?
    var isSender: Bool
}

class MessageManager {
    var Messages = [Message]()
    let db = Firestore.firestore()
    var ref : DocumentReference? = nil
    
    func getMessageRoom(){
        
        
    }
    func addRoom(with:String,name:String){
        ref = db.collection("/room").addDocument(data: [
            "people":with,
            "name":name
        ]){
            _ in
        }
    }
    
    init(){
       
    }
}
