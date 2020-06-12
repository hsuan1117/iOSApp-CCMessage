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
    
    func addMessage(id:String,message:String){
        var ref : DocumentReference? = nil
        
        ref = db.collection("messages").addDocument(data: [
            "content":message,
            "sender":uid!,
            "timestamp":Date().unixTimestamp
        ]){ error in
            let messageID = ref!.documentID
            ref = self.db.collection("rooms").document(id)
            ref?.updateData([
                "messages":FieldValue.arrayUnion([messageID])
            ]){ error in
                
            }
        }
    }
    func deleteMessage(id:String,roomID:String,completion:@escaping ()->()){
        var ref : DocumentReference? = nil
        ref = db.collection("messages").document(id)
        ref!.delete() { error in
            ref = self.db.collection("rooms").document(roomID)
            ref?.updateData([
                "messages":FieldValue.arrayRemove([id])
            ]){ error in
                completion()
            }
        }
    }
    
    func addRoom(with:[String],name:String,completion:@escaping ()->()){
        var ref : DocumentReference? = nil
        var participant = with
        participant.append(uid!)
        ref = db.collection("rooms").addDocument(data: [
            "messages":[],
            "participant":participant,
            "name":name
        ]){ error in
            let roomID = ref!.documentID
            for x in participant {
                ref = self.db.collection("users").document(x)
                ref?.updateData([
                    "rooms":FieldValue.arrayUnion([roomID])
                ]){ error in
                    if(participant.last == x){
                        completion()
                    }
                }
            }
            
        }
    }
    func deleteRoom(id:String,completion:@escaping ()->()){
        var ref : DocumentReference? = nil
        var participant : Array<String> = []
        ref = db.collection("rooms").document(id)
        ref?.getDocument(completion: {
            (r,error) in
            participant = r!["participant"] as! Array<String>
        })
        ref!.delete() { error in
            for x in participant {
                ref = self.db.collection("users").document(x)
                ref?.updateData([
                    "rooms":FieldValue.arrayRemove([id])
                ]){ error in
                    if(participant.last == x){
                        completion()
                    }
                }
            }
            
        }
    }
    init(){
       
    }
}

// MARK: - Database Structure
/**
 * users
 *   -
 *
 */
