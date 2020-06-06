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
    var name        : String
    var id          : String
    var participant : [String]
}

struct RoomUser : MSGUser {
    var displayName: String
    var avatar: UIImage?
    var avatarUrl: URL?
    var isSender: Bool
}

class MessageManager {
    var Messages = [Message]()
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    func getMessageRoom(){
        
        
    }
    func addRoom(with:[String],name:String){
        var ref : DocumentReference? = nil
        var participant = with
        participant.append(uid!)
        ref = db.collection("rooms").addDocument(data: [
            "participant":participant,
            "name":name
        ])
        let roomID = ref!.documentID
        
        ref = db.collection("users").document(uid!)
        ref?.updateData([
            "rooms":FieldValue.arrayUnion([roomID])
        ])
    }
    
    init(){
       
    }
}
