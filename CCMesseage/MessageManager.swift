//
//  MessageManager.swift
//  CCMesseage
//
//  Created by student on 2020/5/29.
//  Copyright © 2020 hsuan. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    var title   : String
    var author  : String
    var url     : String
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
